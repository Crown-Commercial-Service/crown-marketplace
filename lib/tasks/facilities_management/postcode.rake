# rubocop:disable Metrics/ModuleLength
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

  # rubocop:disable Metrics/MethodLength
  def self.create_new_postcode_views
    query = <<~SQL
      CREATE OR REPLACE VIEW public.os_address_view_2
       AS
       SELECT
              CASE
                  WHEN NULLIF(adds.rm_organisation_name::text, ''::text) IS NULL THEN NULL::character varying
                  ELSE adds.rm_organisation_name
              END AS organisation,
              CASE
                  WHEN btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) = COALESCE(adds.building_name, adds.sub_building_name)::text THEN NULL::text
                  WHEN NULLIF(
                  CASE
                      WHEN NULLIF(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name::text
                      ELSE
                      CASE
                          WHEN NULLIF(adds.building_name::text, ''::text) IS NULL THEN adds.sub_building_name::text
                          ELSE adds.sub_building_name::text || ', '::text
                      END || COALESCE(adds.building_name, ''::text::character varying)::text
                  END, ''::text) IS NULL THEN NULL::text
                  ELSE
                  CASE
                      WHEN NULLIF(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name::text
                      ELSE
                      CASE
                          WHEN NULLIF(adds.building_name::text, ''::text) IS NULL THEN adds.sub_building_name::text
                          ELSE adds.sub_building_name::text || ', '::text
                      END || COALESCE(adds.building_name, ''::text::character varying)::text
                  END
              END AS building,
              CASE
                  WHEN NULLIF(adds.sao_text::text, ''::text) IS NULL THEN
                  CASE
                      WHEN NULLIF(adds.pao_text::text, ''::text) IS NULL THEN NULL::character varying
                      ELSE adds.pao_text
                  END::text
                  ELSE adds.sao_text::text ||
                  CASE
                      WHEN NULLIF(adds.pao_text::text, ''::text) IS NULL THEN ''::text
                      ELSE ', '::text || adds.pao_text::text
                  END
              END AS addressable_object,
              CASE
                  WHEN NULLIF(btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text, ''::text) IS NULL THEN ''::text
                  ELSE btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text
              END || adds.street_description::text AS street_address,
              CASE
                  WHEN NULLIF(adds.dependent_locality::text, ''::text) IS NULL THEN ''::text
                  ELSE adds.dependent_locality::text || ', '::text
              END ||
              CASE
                  WHEN NULLIF(adds.post_town::text, ''::text) IS NULL THEN adds.town_name
                  ELSE adds.post_town
              END::text AS postal_town,
              CASE
                  WHEN NULLIF(adds.postcode::text, ''::text) IS NULL THEN NULL::character varying
                  ELSE adds.postcode
              END AS postcode,
          adds.postcode_locator,
          NULLIF(adds.sub_building_name::text, ''::text) AS sub_building_name,
          NULLIF(adds.building_name::text, ''::text) AS building_name,
          NULLIF(adds.pao_text::text, ''::text) AS pao_name,
          NULLIF(adds.sao_text::text, ''::text) AS sao_name,
          btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) AS house_number,
          adds.street_description,
          NULLIF(adds.dependent_locality::text, ''::text) AS village,
              CASE
                  WHEN NULLIF(adds.post_town::text, ''::text) IS NULL THEN adds.town_name
                  ELSE adds.post_town
              END AS post_town,
          replace(adds.postcode_locator::text, ' '::text, ''::text) AS formatted_postcode,
          replace(adds.postcode_locator::text, ' '::text, adds.delivery_point_suffix::text) AS building_ref
         FROM os_address adds;
    SQL
    puts 'creating os_address_view_2'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = <<~SQL
      CREATE OR REPLACE VIEW public.postcode_region_view
                AS
                SELECT nuts.code AS region_code,
                   nuts3.name AS region,
                   nuts.postcode
                  FROM postcodes_nuts_regions nuts
                    JOIN nuts_regions nuts3 ON nuts3.code::text = nuts.code::text;
    SQL
    puts 'creating postcode_region_view'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = <<~SQL
      CREATE OR REPLACE VIEW public.postcode_lookup
       AS
           SELECT ((((
            CASE
                WHEN addresses.organisation IS NOT NULL AND NULLIF("position"(addresses.addressable_object, addresses.organisation::text), 0) IS NULL THEN initcap(addresses.organisation::text) || ', '::text
                ELSE ''::text
            END ||
            CASE
                WHEN addresses.addressable_object IS NOT NULL THEN initcap(addresses.addressable_object) || ', '::text
                WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::text
                ELSE ''::text
            END) ||
            CASE
                WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ', '::text
                ELSE initcap(addresses.street_description::text) || ', '::text
            END) || initcap(addresses.postal_town)) || ''::text) AS summary_line,
              CASE
      			WHEN addresses.organisation IS NOT NULL THEN
      				case when addresses.addressable_object is not null then
      					initcap(addresses.organisation::text) || ', '::text || initcap(addresses.addressable_object)
      				else
      					initcap(addresses.organisation::text) || ''::text
      				end
         	        WHEN addresses.addressable_object is not null then initcap(addresses.addressable_object) || ''::text
                  ELSE
      				CASE
      					WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::text
      					ELSE ''::text
      				END ||
      				CASE
      					WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::text
      					ELSE initcap(addresses.street_description::text) || ''::text
      				END
              END AS address_line_1,
              CASE
      			WHEN addresses.addressable_object is not null or addresses.organisation IS NOT NULL then
      				CASE
      					WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::text
      					ELSE initcap(addresses.street_description::text) || ''::text
      				END
      			ELSE
      				''::text
              END AS address_line_2,
          initcap(addresses.postal_town) AS address_town,
          addresses.postcode_locator AS address_postcode,
          initcap(regions.region::text) AS address_region,
          regions.region_code AS address_region_code
         FROM os_address_view_2 addresses
           LEFT outer JOIN postcode_region_view regions ON regions.postcode::text = replace(addresses.postcode_locator::text, ' '::text, ''::text);
    SQL
    puts 'creating postcode_lookup_view'
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

namespace :db do
  desc 'add OS postcode data to the database'
  # task :postcode, [:access_key, :secret_access_key, :bucket, :region] => :environment do |_, args|
  task webpostcode: :environment do |_, args|
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_new_postcode_views
    OrdnanceSurvey.import_postcodes args[:access_key], args[:secret_access_key], args[:bucket], args[:region]
  end

  task postcode: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_new_postcode_views
    OrdnanceSurvey.create_upload_log

    ENV['RAILS_MASTER_KEY_2'] = ENV['SECRET_KEY_BASE'][0..31] if ENV['SECRET_KEY_BASE']
    creds                     = ActiveSupport::EncryptedConfiguration.new(
      config_path: Rails.root.join('config', 'credentials.yml.enc'),
      key_path: 'config/master.key',
      env_key: 'RAILS_MASTER_KEY_2',
      raise_if_missing_key: false
    )

    access_key = creds.aws_postcodes[:access_key_id]
    secret_key = creds.aws_postcodes[:secret_access_key]
    bucket     = creds.aws_postcodes[:bucket]
    region     = creds.aws_postcodes[:region]

    DistributedLocks.distributed_lock(151) do
      OrdnanceSurvey.import_postcodes access_key, secret_key, bucket, region
    end
  end

  desc 'create OS postcode table'
  task pctable: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    p 'Creating address lookup view'
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_new_postcode_views
  end
end
# rubocop:enable Metrics/ModuleLength
