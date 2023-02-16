module CCS
  require 'pg'
  require 'csv'
  require 'json'
  require Rails.root.join('lib', 'tasks', 'distributed_locks')
  require Rails.root.join('lib', 'tasks', 'ordnance_survey')

  def self.csv_to_nuts_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS nuts_regions (code varchar(255) UNIQUE, name varchar(255),
      nuts1_code varchar(255), nuts2_code varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| "\"#{i}\"" }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM nuts_regions where code = '#{row['code']}' ; ")
        db.exec_query("insert into nuts_regions ( #{column_names}) values (#{values})")
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.csv_to_fm_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS facilities_management_regions (code varchar(255) UNIQUE, name varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| "\"#{i}\"" }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM facilities_management_regions where code = '#{row['code']}' ; ")
        db.exec_query("insert into facilities_management_regions ( #{column_names}) values (#{values})")
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.load_fm_nuts_data(directory)
    DistributedLocks.distributed_lock(150) do
      puts "Loading NUTS static data, Environment: #{Rails.env}"
      CCS.csv_to_nuts_regions "#{directory}nuts1_regions.csv"
      CCS.csv_to_nuts_regions "#{directory}nuts2_regions.csv"
      CCS.csv_to_nuts_regions "#{directory}nuts3_regions.csv"
      puts "Finished loading NUTS codes into db #{Rails.application.config.database_configuration[Rails.env]['database']}"
    end
  end

  def self.load_fm_regions_data(directory)
    DistributedLocks.distributed_lock(150) do
      puts 'Loading FM regions static data'
      CCS.csv_to_fm_regions "#{directory}facilities_management/regions.csv"
      puts 'Finished loading static data'
    end
  end

  def self.load_nuts_regions(directory = 'data/')
    CCS.load_fm_nuts_data directory
    CCS.load_fm_regions_data directory
  end
end

namespace :db do
  desc 'add NUTS regions to the database'
  task regions: :environment do
    puts 'Loading NUTS regions'
    CCS.load_nuts_regions
  end

  desc 'add NUTS regions to the database'
  task static: :regions
end
