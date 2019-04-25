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

      file = File.read('data/' + 'facilities_management/dummy_supplier_data.json')
      data = JSON file
      puts "Uploading #{data.size} suppliers"

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

  def self.facilities_management_buildings
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "create table if not exists public.facilities_management_buildings (user_id varchar not null, building_json jsonb not null);
       DROP INDEX IF EXISTS buildings_idx; CREATE INDEX IF NOT EXISTS idx_buildings_service ON facilities_management_buildings USING GIN ((building_json -> 'services'));
       "
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end
end
namespace :db do
  desc 'add NUTS static data to the database'
  task static: :environment do
    p 'Loading NUTS static'
    CCS.load_static
    p 'Loading FM Suppliers static'
    CCS.fm_suppliers
    p 'Creating FM building database'
    CCS.facilities_management_buildings
  end
  desc 'add static data to the database'
  task setup: :static do
  end
end
