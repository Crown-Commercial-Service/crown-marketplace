module CCS
  require 'pg'
  require 'csv'
  require 'json'

  def self.csv_to_nuts_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS nuts_regions (code varchar(255) UNIQUE, name varchar(255),
      nuts1_code varchar(255), nuts2_code varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM nuts_regions where code = '" + row['code'] + "' ; ")
        db.exec_query('insert into nuts_regions ( ' + column_names + ') values (' + values + ')')
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.csv_to_fm_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS fm_regions (code varchar(255) UNIQUE, name varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM fm_regions where code = '" + row['code'] + "' ; ")
        db.exec_query('insert into fm_regions ( ' + column_names + ') values (' + values + ')')
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.csv_to_fm_rates(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'create table IF NOT EXISTS fm_rates (code varchar(255) UNIQUE, framework numeric, benchmark numeric );'
      db.query query
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        query = "DELETE FROM fm_rates where code = '" + row['code'] + "' ; " \
                'insert into fm_rates ( ' + column_names + ') values (' + values + ')'
        db.query query
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.load_static(directory = 'data/')
    p "Loading NUTS static data, Environment: #{Rails.env}"
    CCS.csv_to_nuts_regions directory + 'nuts1_regions.csv'
    CCS.csv_to_nuts_regions directory + 'nuts2_regions.csv'
    CCS.csv_to_nuts_regions directory + 'nuts3_regions.csv'
    p "Finished loading NUTS codes into db #{Rails.application.config.database_configuration[Rails.env]['database']}"

    CCS.csv_to_fm_regions directory + 'facilities_management/regions.csv'
    p 'Loading FM rates static data'
    CCS.csv_to_fm_rates directory + 'facilities_management/rates.csv'
  end

  def self.fm_suppliers
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'CREATE TABLE IF NOT EXISTS fm_suppliers ( supplier_id UUID PRIMARY KEY, data jsonb,' \
              '  created_at timestamp without time zone NOT NULL,  updated_at timestamp without time zone NOT NULL);' \
              'CREATE INDEX IF NOT EXISTS idxgin ON fm_suppliers USING GIN (data);' \
              'CREATE INDEX IF NOT EXISTS idxginp ON fm_suppliers USING GIN (data jsonb_path_ops);' \
              "CREATE INDEX IF NOT EXISTS idxginlots ON fm_suppliers USING GIN ((data -> 'lots'));"
      db.query query

      is_dev =  ENV['CCS_DEFAULT_DB_HOST']
      
      if ENV['SECRET_KEY_BASE'] 
        data = self.fm_aws
        data = JSON data
      else
        file = File.read('data/' + 'facilities_management/dummy_supplier_data.json')
        data = JSON file
        puts "Uploading #{data.size} suppliers"
      end

      data.each do |supplier|
        values = supplier.to_json.gsub("'") { "''" }
        query = "DELETE FROM fm_suppliers where data->'supplier_id' ? '" + supplier['supplier_id'] + "' ; " \
                'insert into fm_suppliers ( created_at, updated_at, supplier_id, data ) values ( now(), now(), \'' \
                          + supplier['supplier_id'] + "', '" + values + "')"
        db.query query
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.extend_timeout
    Aws.config[:http_open_timeout] = 600
    Aws.config[:http_read_timeout] = 600
    Aws.config[:http_idle_timeout] = 600
  end

  def self.awd_credentials(access_key, secret_key, bucket, region)
    Aws.config[:credentials] = Aws::Credentials.new(access_key, secret_key)
    p "Importing from AWS bucket: #{bucket}, region: #{region}"

    extend_timeout
  end

  # EDITOR=vim rails credentials:edit
  def self.fm_aws
    current_key = ENV['RAILS_MASTER_KEY']
    ENV['RAILS_MASTER_KEY'] = ENV['SECRET_KEY_BASE'][0..31]
    # ENV["RAILS_MASTER_KEY"] = '1234567890ABCDEF1234567890ABCDEF'

    access_key = Rails.application.credentials.aws[:access_key_id]
    secret_key = Rails.application.credentials.aws[:secret_access_key]
    bucket = Rails.application.credentials.aws[:bucket]
    region = Rails.application.credentials.aws[:region]

    val = import_suppliers(access_key, secret_key, bucket, region)

    return val
  rescue StandardError => e
    puts e.message
  ensure
    ENV['RAILS_MASTER_KEY'] = current_key
  end

  def self.import_suppliers(access_key, secret_key, bucket, region)
    awd_credentials access_key, secret_key, bucket, region

    object = Aws::S3::Resource.new(region: region)
    object.bucket(bucket).objects.each do |obj|
      next unless obj.key.starts_with? 'suppliers/data/final'

      p 'Loading ' + obj.key

      data = obj.get.body
      return data.string
    rescue PG::Error => e
      puts e.message
    end
  end
end

namespace :db do
  desc 'add NUTS static data to the database'
  task static: :environment do
    p 'Loading NUTS static'
    CCS.load_static
    p 'Loading FM Suppliers static'
    CCS.fm_suppliers
  end
  desc 'download from aws'
  task aws: :environment do
    p 'Loading FM Suppliers static'
    CCS.fm_suppliers
  end
  desc 'add static data to the database'
  task setup: :static do
  end
end
