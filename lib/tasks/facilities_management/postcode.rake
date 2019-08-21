module OrdnanceSurvey
  require 'aws-sdk-s3'
  require 'json'
  require './lib/tasks/distributed_locks'

  def self.create_postcode_table
    str = File.read(Rails.root + 'data/postcode/PostgreSQL_AddressBase_Plus_CreateTable.sql')
    query = str.slice str.index('CREATE TABLE')..str.length
    query.sub!('<INSERTTABLENAME>', 'os_address')
    query.sub!('CREATE TABLE', 'CREATE TABLE IF NOT EXISTS')
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = 'CREATE INDEX IF NOT EXISTS idx_postcode ON os_address USING btree (postcode);'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  end

  def self.create_address_lookup_view
    query = "CREATE OR REPLACE VIEW public.os_address_view
AS SELECT ((adds.pao_start_number || adds.pao_start_suffix::text) || ' '::text) || adds.street_description::text AS add1,
    adds.town_name AS village,
    adds.post_town,
    adds.administrative_area AS county,
    adds.postcode
   FROM os_address adds
  WHERE ((adds.pao_start_number || adds.pao_start_suffix::text) || adds.street_description::text) IS NOT NULL AND adds.post_town IS NOT NULL
  ORDER BY adds.pao_start_number, adds.street_description;
"
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

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
      count = result[0]['count']
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
      next unless obj.key.starts_with? 'AddressBasePlus/data/AddressBase'

      next if postcode_file_already_loaded(obj.key)

      # rc.put_copy_data(obj.get.body)
      # obj.get.body.each_line { |line| rc.put_copy_data(line) }
      puts "*** Loading file #{obj.key}"
      chunks = ''
      obj.get do |chunk|
        # rc.put_copy_data chunk
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
    OrdnanceSurvey.import_postcodes args[:access_key], args[:secret_access_key], args[:bucket], args[:region]
  end

  task postcode: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_upload_log

    ENV['RAILS_MASTER_KEY_2'] = ENV['SECRET_KEY_BASE'][0..31] if ENV['SECRET_KEY_BASE']
    creds = ActiveSupport::EncryptedConfiguration.new(
        config_path: Rails.root.join('config/credentials.yml.enc'),
        key_path: 'config/master.key',
        env_key: 'RAILS_MASTER_KEY_2',
        raise_if_missing_key: false # config.require_master_key
    )

    access_key = creds.aws_postcodes[:access_key_id]
    secret_key = creds.aws_postcodes[:secret_access_key]
    bucket = creds.aws_postcodes[:bucket]
    region = creds.aws_postcodes[:region]

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
  end
end
