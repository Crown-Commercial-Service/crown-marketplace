# rubocop:disable Metrics/ModuleLength, Rails/Output
module OrdnanceSurvey
  require 'csv'
  require 'aws-sdk-s3'
  require 'json'
  require Rails.root.join('lib', 'tasks', 'distributed_locks')

  def self.create_postcode_table
    str   = File.read(Rails.root + 'data/postcode/PostgreSQL_AddressBase_Plus_CreateTable.sql')
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
    query = <<~SQL
      CREATE INDEX IF NOT EXISTS index_os_address_on_postcode_locator
      ON public.os_address USING btree
      (postcode_locator ASC NULLS LAST);
    SQL
    puts 'creating new index on os_address'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  end

  # rubocop:disable Metrics/MethodLength
  def self.create_new_postcode_views
    query = <<~SQL
      DO $$
      BEGIN
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
          WHERE (adds.class::TEXT !~~ 'O%'::TEXT OR adds.class::TEXT ~~ 'OT%'::TEXT OR adds.class::TEXT ~~ 'OE%'::TEXT
                     OR adds.class::TEXT ~~ 'OH%'::TEXT OR adds.class::TEXT ~~ 'ON%'::TEXT OR adds.class::TEXT ~~ 'OP%'::TEXT
                     OR adds.class::TEXT ~~ 'OO%'::TEXT OR adds.class::TEXT ~~ 'OS%'::TEXT OR adds.class::TEXT ~~ 'OI02%'::TEXT
                     OR adds.class::TEXT ~~ 'OI06%'::TEXT)
                AND adds.class::TEXT !~~ 'U%'::TEXT
                AND adds.class::TEXT !~~ 'CH%'::TEXT
                AND adds.class::TEXT !~~ 'CZ%'::TEXT
                AND adds.class::TEXT !~~ 'P%'::TEXT
                AND adds.class::TEXT !~~ 'CU11%'::TEXT;
      EXCEPTION
        WHEN SQLSTATE '42P07' THEN
          NULL;
      END; $$
    SQL
    p 'creating os_address_view_2'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = <<~SQL
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
    query = <<~SQL
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
                          ELSE ''::TEXT
          END                                                                          AS address_line_2
                    , initcap(addresses.postal_town)                                   AS address_town
                    , addresses.postcode_locator                                       AS address_postcode
                    , initcap(regions.region::TEXT)                                    AS address_region
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

    # -- Indices -------------------------------------------------------
    query = "
CREATE UNIQUE INDEX IF NOT EXISTS os_address_admin_uploads_filename_idx ON os_address_admin_uploads USING btree (filename);"
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

  def self.postcode_file_already_loaded(key)
    p "Checking file #{key}"

    query = "select count(*) from os_address_admin_uploads where filename = '#{key}'"

    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query(query)
      count  = result[0]['count']
      count.positive?
    end
  rescue PG::Error => e
    puts e.message
    false
  end

  def self.log_postcode_file_loaded(key, size, etag, created_at, updated_at)
    query = "
    INSERT INTO os_address_admin_uploads (filename, size, etag, created_at, updated_at) VALUES('#{key}', #{size}, '#{etag}', '#{created_at}', '#{updated_at}');"
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query(query)
      puts result
    end
  rescue PG::Error => e
    puts e.message
    false
  end

  def self.awd_credentials(access_key, secret_key, bucket, region)
    Aws.config[:credentials] = Aws::Credentials.new(access_key, secret_key)
    p "Importing from AWS bucket: #{bucket}, region: #{region}"

    extend_timeout
  end

  def self.extend_timeout
    Aws.config[:http_open_timeout] = 6000
    Aws.config[:http_read_timeout] = 6000
    Aws.config[:http_idle_timeout] = 6000
  end

  # rubocop:disable Metrics/AbcSize
  def self.import_postcodes(access_key, secret_key, bucket, region)
    awd_credentials access_key, secret_key, bucket, region

    object = Aws::S3::Resource.new(region: region)
    object.bucket(bucket).objects.each do |obj|
      next unless obj.key.starts_with? 'dataPostcode2files'

      next if postcode_file_already_loaded(obj.key)

      # rc.put_copy_data(obj.get.body)
      # obj.get.body.each_line { |line| rc.put_copy_data(line) }
      puts "*** Loading file #{obj.key}"
      chunks = ''
      obj.get do |chunk|
        chunks << chunk
      end
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        rc = conn.raw_connection
        rc.exec('COPY os_address FROM STDIN WITH CSV')
        rc.put_copy_data chunks
        rc.put_copy_end
      end

      log_postcode_file_loaded(obj.data.key, obj.data.size, obj.data.etag, obj.data.last_modified, DateTime.now.utc)
    end
  rescue PG::Error => e
    puts e.message
  end
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength, Rails/Output
