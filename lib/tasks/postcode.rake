module OrdnanceSurvey
  require 'aws-sdk-s3'
  require 'json'

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

  def self.import_postcodes(access_key, secret_key, bucket, region)
    awd_credentials access_key, secret_key, bucket, region

    ActiveRecord::Base.connection_pool.with_connection do |conn|
      object = Aws::S3::Resource.new(region: region)
      object.bucket(bucket).objects.each do |obj|
        next unless obj.key.starts_with? 'AddressBasePlus/data/AddressBase'

        p "Checking file #{obj.key}"

        # rc.put_copy_data(obj.get.body)
        # obj.get.body.each_line { |line| rc.put_copy_data(line) }
        puts "*** Loading file #{obj.key}"
        chunks = ''
        obj.get do |chunk|
          # rc.put_copy_data chunk
          chunks << chunk
        end
        rc = conn.raw_connection
        rc.exec('COPY os_address FROM STDIN WITH CSV')
        rc.put_copy_data chunks
        rc.put_copy_end
      end
    end
  rescue PG::Error => e
    puts e.message
  end
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

    # current_key = ENV['RAILS_MASTER_KEY']
    ENV['RAILS_MASTER_KEY'] = ENV['SECRET_KEY_BASE'][0..31] if ENV['SECRET_KEY_BASE']

    access_key = Rails.application.credentials.aws_postcodes[:access_key_id]
    secret_key = Rails.application.credentials.aws_postcodes[:secret_access_key]
    bucket = Rails.application.credentials.aws_postcodes[:bucket]
    region = Rails.application.credentials.aws_postcodes[:region]

    # 'SELECT pg_try_advisory_lock_shared(1234);'
    query = 'SELECT pg_try_advisory_lock(151);'
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query query
      puts db
      puts "Distributed lock #{result}"
    end

    OrdnanceSurvey.import_postcodes access_key, secret_key, bucket, region

    # 'SELECT pg_advisory_unlock_shared(1234);'
    query = 'SELECT pg_advisory_unlock(151);'
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query query
      puts db
      puts "Distributed unlock #{result}"
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
