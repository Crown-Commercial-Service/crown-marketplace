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

  def self.awd_credentials
    @secrets = JSON.parse(File.read(Rails.root.to_s + '/../aws-secrets.json'))
    Aws.config[:credentials] = Aws::Credentials.new(@secrets['AccessKeyId'], @secrets['SecretAccessKey'])
    p "Importing from AWS bucket: #{@secrets['bucket']}, region: #{@secrets['region']}"

    extend_timeout
  end

  def self.extend_timeout
    Aws.config[:http_open_timeout] = 600
    Aws.config[:http_read_timeout] = 600
    Aws.config[:http_idle_timeout] = 600
  end

  def self.import_postcodes
    create_postcode_table
    awd_credentials

    object = Aws::S3::Resource.new(region: @secrets['region'])
    object.bucket(@secrets['bucket']).objects.each do |obj|
      next unless obj.key.starts_with? 'AddressBasePlus/data/AddressBase'

      p 'Loading ' + obj.key
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        rc = conn.raw_connection
        rc.exec('COPY os_address FROM STDIN WITH CSV')
        rc.put_copy_data(obj.get.body.read)
        rc.put_copy_end
      end
    end
  rescue PG::Error => e
    puts e.message
  end
end

namespace :db do
  desc 'add OS postcode data to the database'
  task postcode: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.import_postcodes
  end

  desc 'create OS postcode table'
  task pctable: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    p 'Creating address lookup view'
    OrdnanceSurvey.create_address_lookup_view
  end

  # desc 'add postcode static data to the database'
  # task static: :postcode do
  # end
end
