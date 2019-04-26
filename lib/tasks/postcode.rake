module OrdnanceSurvey
  require 'aws-sdk-s3'
  require 'json'

  def create_postcode_table
    str = File.read(Rails.root + 'data/postcode/PostgreSQL_AddressBase_Plus_CreateTable.sql')
    query = str.slice str.index('CREATE TABLE')..str.length
    query.sub!('<INSERTTABLENAME>', 'os_address')
    query.sub!('CREATE TABLE', 'CREATE TABLE IF NOT EXISTS')
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  end

  def awd_credentials
    creds = JSON.parse(File.read(Rails.root.to_s + '/../aws-secrets.json'))
    Aws.config[:credentials] = Aws::Credentials.new(creds['AccessKeyId'], creds['SecretAccessKey'])
  end

  def self.import_postcodes
    create_postcode_table
    awd_credentials

    object = Aws::S3::Resource.new
    object.bucket('ccs-postcodes').objects.each do |obj|
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
  desc 'add FM postcode data to the database'
  task postcode: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.import_postcodes
  end
  # desc 'add postcode static data to the database'
  # task static: :postcode do
  # end
end
