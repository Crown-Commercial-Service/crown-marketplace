require 'smarter_csv'
require 'rubygems/package'
require 'digest/md5'
require 'active_support'
require 'open-uri'

# rubocop:disable Metrics/ModuleLength, Rails/Output
module OrdnanceSurvey
  require 'csv'
  require 'aws-sdk-s3'
  require 'json'
  require Rails.root.join('lib', 'tasks', 'distributed_locks')
  require Rails.root.join('lib', 'tasks', 'os_data_processing')
  require Rails.root.join('lib', 'tasks', 'os_file_handler')
  require Rails.root.join('lib', 'tasks', 'os_stream_handler')

  extend ActiveSupport::NumberHelper

  def self.create_postcode_table
    str   = Rails.root.join('data', 'postcode', 'PostgreSQL_AddressBase_Plus_CreateTable.sql').read
    query = str.slice str.index('CREATE TABLE')..str.length
    query.sub!('<INSERTTABLENAME>', 'os_address')
    query.sub!('CREATE TABLE', 'CREATE TABLE IF NOT EXISTS')
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = 'CREATE INDEX IF NOT EXISTS idx_postcode ON os_address USING btree (postcode);'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  end

  def self.create_address_lookup_view
    query = "create or replace view public.os_address_view as select trim(((nullif(adds.rm_organisation_name, ' ') || ' ' || adds.pao_start_number || adds.pao_start_suffix::text) || ' '::text) || adds.street_description::text) as add1,
                adds.town_name as village, adds.post_town, adds.administrative_area as county, adds.postcode, replace(adds.postcode::text, ' '::text, ''::text) as formated_postcode,
                replace(adds.postcode::text, ' '::text, adds.delivery_point_suffix::text) as building_ref
              from os_address adds where ((adds.pao_start_number || adds.pao_start_suffix::text) || adds.street_description::text) is not null
                and adds.post_town is not null order by
                adds.pao_start_number, adds.rm_organisation_name, adds.street_description;"
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

  def self.create_postcode_locator_index
    query = <<~SQL.squish
      CREATE INDEX IF NOT EXISTS index_os_address_on_postcode_locator
      ON public.os_address USING btree
      (postcode_locator ASC NULLS LAST);
    SQL
    puts 'creating new index on os_address'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  end

  # rubocop:disable Metrics/MethodLength
  def self.create_new_postcode_views
    query = <<~SQL.squish
        DO $$
        BEGIN
        drop view if exists postcode_lookup cascade;
        drop view if exists os_address_view_2 cascade;
        CREATE VIEW os_address_view_2
        (building, street_address, postal_town, postcode_locator, sub_building_name, building_name, pao_name,
         sao_name, house_number, street_description, village, post_town, formatted_postcode, building_ref, uprn,
         class)
        AS
        SELECT CASE
        WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL AND
        NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL AND NULLIF(adds.pao_text::TEXT, ''::TEXT) IS NOT NULL
        THEN adds.pao_text::TEXT || ''::TEXT
        WHEN btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) =
        COALESCE(adds.building_name, adds.sub_building_name)::TEXT THEN NULL::TEXT
        WHEN NULLIF(
                    CASE
                    WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL THEN adds.building_name::TEXT
                    ELSE
                    CASE
                    WHEN NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL THEN adds.sub_building_name::TEXT
                    ELSE adds.sub_building_name::TEXT || ', '::TEXT
                    END || COALESCE(adds.building_name, ''::TEXT::CHARACTER VARYING)::TEXT
                    END, ''::TEXT) IS NULL THEN NULL::TEXT
        ELSE
        CASE
        WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL THEN adds.building_name::TEXT
        ELSE
        CASE
        WHEN NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL THEN adds.sub_building_name::TEXT
        ELSE adds.sub_building_name::TEXT || ', '::TEXT
        END || COALESCE(adds.building_name, ''::TEXT::CHARACTER VARYING)::TEXT
        END
        END                                                                                  AS building
        , CASE
        WHEN NULLIF(btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) || ' '::TEXT,
                    ''::TEXT) IS NULL THEN ''::TEXT
        ELSE btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) || ' '::TEXT
        END || adds.street_description::TEXT                                          AS street_address
        , CASE
        WHEN NULLIF(adds.dependent_locality::TEXT, ''::TEXT) IS NULL THEN ''::TEXT
        ELSE adds.dependent_locality::TEXT || ', '::TEXT
        END ||
        CASE
        WHEN NULLIF(adds.post_town::TEXT, ''::TEXT) IS NULL THEN adds.town_name
        ELSE adds.post_town
        END::TEXT                                                                     AS postal_town
        , adds.postcode_locator
        , NULLIF(adds.sub_building_name::TEXT, ''::TEXT)                                    AS sub_building_name
        , NULLIF(adds.building_name::TEXT, ''::TEXT)                                        AS building_name
        , NULLIF(adds.pao_text::TEXT, ''::TEXT)                                             AS pao_name
        , NULLIF(adds.sao_text::TEXT, ''::TEXT)                                             AS sao_name
        , btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT)   AS house_number
        , adds.street_description
        , NULLIF(adds.dependent_locality::TEXT, ''::TEXT)                                   AS village
        , CASE
        WHEN NULLIF(adds.post_town::TEXT, ''::TEXT) IS NULL THEN adds.town_name
        ELSE adds.post_town
        END                                                                                  AS post_town
        , replace(adds.postcode_locator::TEXT, ' '::TEXT, ''::TEXT)                         AS formatted_postcode
        , replace(adds.postcode_locator::TEXT, ' '::TEXT, adds.delivery_point_suffix::TEXT) AS building_ref
        , adds.uprn
        , adds.class
            FROM os_address adds
            WHERE (adds.class::TEXT !~~ 'O%'::TEXT OR adds.class::TEXT ~~ 'OE%'::TEXT OR adds.class::TEXT ~~ 'OH%'::TEXT OR
            adds.class::TEXT ~~ 'ON%'::TEXT OR adds.class::TEXT ~~ 'OP%'::TEXT OR adds.class::TEXT ~~ 'OS%'::TEXT)
            AND adds.class::TEXT !~~ 'U%'::TEXT
            AND adds.class::TEXT !~~ 'CH%'::TEXT
            AND adds.class::TEXT !~~ 'CZ%'::TEXT
            AND adds.class::text !~~ 'PS'::text
            AND adds.class::TEXT !~~ 'CU11%'::TEXT;
      EXCEPTION
          WHEN SQLSTATE '42P07' THEN
            NULL;
        END; $$
    SQL
    p 'creating os_address_view_2'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = <<~SQL.squish
      DO $$
      BEGIN
        CREATE VIEW public.postcode_region_view
        AS
        SELECT nuts.code AS region_code,
           nuts3.name AS region,
           nuts.postcode
        FROM postcodes_nuts_regions nuts
          JOIN nuts_regions nuts3 ON nuts3.code::text = nuts.code::text;
      EXCEPTION
        WHEN SQLSTATE '42P07' THEN
          NULL;
      END; $$
    SQL
    p 'creating postcode_region_view'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = <<~SQL.squish
        DO $$
        BEGIN
        CREATE VIEW postcode_lookup
        (summary_line, address_line_1, address_line_2, address_town, address_postcode, address_region,
        address_region_code) AS
        SELECT DISTINCT ((
        CASE
        WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::TEXT
        ELSE ''::TEXT
        END ||
        CASE
        WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ', '::TEXT
        ELSE initcap(addresses.street_description::TEXT) || ', '::TEXT
        END) || initcap(addresses.postal_town)) || ''::TEXT AS summary_line
        , CASE
        WHEN addresses.building IS NOT NULL THEN initcap(addresses.building)
        WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::TEXT
        ELSE initcap(addresses.street_description::TEXT) || ''::TEXT
        END                                                                          AS address_line_1
        , CASE
        WHEN addresses.building IS NOT NULL AND addresses.street_address IS NOT NULL
        THEN initcap(addresses.street_address) || ''::TEXT
        WHEN addresses.building IS NOT NULL THEN initcap(addresses.street_description::TEXT) || ''::TEXT
        ELSE NULL::TEXT
        END                                                                AS address_line_2
        , initcap(addresses.postal_town)                                   AS address_town
        , addresses.postcode_locator                                       AS address_postcode
        , regions.region                                                   AS address_region
        , regions.region_code                                              AS address_region_code
        FROM os_address_view_2              addresses
        LEFT JOIN postcode_region_view regions
        ON regions.postcode::TEXT = replace(addresses.postcode_locator::TEXT, ' '::TEXT, ''::TEXT);
      EXCEPTION
          WHEN SQLSTATE '42P07' THEN
            NULL;
        END; $$
    SQL
    p 'creating postcode_lookup_view'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

  # rubocop:enable Metrics/MethodLength

  def self.create_upload_log
    query = "
      CREATE TABLE IF NOT EXISTS os_address_admin_uploads (
          id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
          filename character varying(255),
          size integer,
          etag character varying(255),
          fail_reason text,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL);"
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }

    query = 'CREATE UNIQUE INDEX IF NOT EXISTS os_address_admin_uploads_filename_idx ON os_address_admin_uploads USING btree (filename);'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

  def self.awd_credentials(access_key, secret_key, bucket, region)
    Aws.config[:credentials] = Aws::Credentials.new(access_key, secret_key)
    p "Importing from AWS bucket: #{bucket}, region: #{region}"

    extend_timeout
  end

  def self.extend_timeout
    Aws.config[:http_open_timeout] = 36000
    Aws.config[:http_read_timeout] = 36000
    Aws.config[:http_idle_timeout] = 36000
  end

  # rubocop:disable Style/ClassVars
  def self.os_address_headers
    @@os_address_headers ||= Rails.root.join('data', 'postcode', 'os_address_headers.csv').read
  end
  # rubocop:enable Style/ClassVars

  def self.file_type(filename)
    return :dat if filename.include? '.dat'

    :csv if filename.include? '.csv'
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def self.import_postcodes_locally(directory)
    if Dir.exist?(directory)
      beginning_time = Time.current
      Dir.entries(directory).reject { |f| File.directory? f }.sort.each do |filename|
        next if filename.starts_with?('.')

        next if postcode_file_already_loaded(File.basename(filename, File.extname(filename)))

        next if File.extname(filename) == '.sh'

        import_local_postcode_file(directory, filename)
      rescue StandardError => e
        p "Error with    #{File.basename(filename, File.extname(filename))}: #{([e.message] + e.backtrace).join($INPUT_RECORD_SEPARATOR)}"
        log_postcode_file_failed(File.basename(filename, File.extname(filename)), e.message)
        Rails.logger.error((["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR))
      end
      p "Purging excluded areas: #{EXCLUDED_POSTCODE_AREAS.map { |e| "'#{e}'" }.join(',')}"
      purge_excluded_areas
      p "Duration: #{Time.current - beginning_time} seconds"
      Rails.logger.info("POSTCODE: Duration #{Time.current - beginning_time}")
    else
      Rails.logger.info("POSTCODE: No folder for local postcode import found (#{directory})")
      p "POSTCODE: No folder for local postcode import found (#{directory})"
    end
  end

  def self.import_sample_addresses
    beginning_time = Time.current
    import_local_postcode_file('data/facilities_management', 'uk_addresses.csv')
    p "Duration: #{Time.current - beginning_time} seconds"
  end

  def self.import_local_postcode_file(directory, filename)
    p "Processing    #{filename}"
    file_time = Time.current
    read_file("#{directory}/#{filename}", method(:process_csv_data)) do |summation|
      p "Duration for #{filename}, of #{number_to_human_size summation[:length]} is #{Time.current - file_time}"
      log_postcode_file_loaded(File.basename(filename, File.extname(filename)), summation[:length],
                               summation[:md5],
                               summation[:updated_time],
                               DateTime.now.utc)
    end
  end

  EXCLUDED_POSTCODE_AREAS = %w[GY IM JE].freeze

  def self.import_postcodes(folder_root, access_key, secret_key, bucket, region)
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0

    # truncate_os_addresses if folder_root == 'dataPostcode2files' # dataPostcode2files is used for originating data
    # updatePostcodeFiles is used to updating the data

    awd_credentials access_key, secret_key, bucket, region

    object = Aws::S3::Resource.new(region: region)
    beginning_time = Time.current
    object.bucket(bucket).objects.each do |obj|
      next if obj.key == "#{folder_root}/" || !obj.key.starts_with?(folder_root)

      next if %w[.sh].select { |ext| obj.key.include? ext }.any?

      next if postcode_file_already_loaded(extract_metadata(File.basename(obj.key, File.extname(obj.key))))

      p "Processing    #{obj.key}"

      file_time = Time.current
      read_file_from_s3(obj, method(:process_csv_data)) do |summation|
        p "Duration for #{obj.key}, of #{ActiveSupport::NumberHelper.number_to_human_size(summation[:length])} is #{Time.current - file_time}"
        log_postcode_file_loaded(obj.key, summation[:length],
                                 summation[:md5],
                                 summation[:updated_time],
                                 DateTime.now.utc)
      end
    rescue Aws::S3::Errors::AccessDenied => e
      Rails.logger.warn "Access denied on #{obj.key}. #{e.message}}"
      puts "*** Access denied on #{obj.key}"
    rescue StandardError => e
      p "\tError: #{e.message}"
      Rails.logger.error((["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR))
      raise e
    end
    p "Purging excluded areas: #{EXCLUDED_POSTCODE_AREAS.map { |e| "'#{e}'" }.join(',')}"
    purge_excluded_areas
    p "Duration: #{Time.current - beginning_time} seconds"
  rescue PG::Error => e
    puts e.message
  end
  # rubocop:enable  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength, Rails/Output
