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

  def self.awd_credentials
    @secrets = JSON.parse(File.read(Rails.root.to_s + '/../aws-secrets.json'))
    Aws.config[:credentials] = Aws::Credentials.new(@secrets['AccessKeyId'], @secrets['SecretAccessKey'])
    p "Importing from AWS bucket: #{@secrets['bucket']}, region: #{@secrets['region']}"
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
  end

  # desc 'add postcode static data to the database'
  # task static: :postcode do
  # end
end
