module CCS
  require 'pg'
  require 'csv'

  def self.csv_to_nuts_regions(file_name, db_config)
    db = PG.connect(db_config)
    query = 'create table IF NOT EXISTS nuts_regions (code varchar(255) UNIQUE, name varchar(255),
                                             nuts1_code varchar(255), nuts2_code varchar(255) );'
    db.query query

    CSV.read(file_name, headers: true).each do |row|
      column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
      values = row.fields.map { |i| "'#{i}'" }.join(',')
      query = "DELETE FROM nuts_regions where code = '" + row['code'] + "' ; " \
             'insert into nuts_regions ( ' + column_names + ') values (' + values + ')'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  ensure
    db&.close
  end

  def self.csv_to_fm_regions(file_name, db_config)
    db = PG.connect(db_config)
    query = 'create table IF NOT EXISTS fm_regions (code varchar(255) UNIQUE, name varchar(255) );'
    db.query query
    CSV.read(file_name, headers: true).each do |row|
      column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
      values = row.fields.map { |i| "'#{i}'" }.join(',')
      query = "DELETE FROM fm_regions where code = '" + row['code'] + "' ; " \
              'insert into fm_regions ( ' + column_names + ') values (' + values + ')'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  ensure
    db&.close
  end

  def self.config
    db_config = Rails.application.config.database_configuration[Rails.env]
    p 'db: ' + db_config['database']
    if Rails.env.production?
      {
        host: db_config['host'],
        port: db_config['port'],
        dbname: db_config['database'],
        user: db_config['username'],
        password: db_config['password']
      }
    else
      { dbname: db_config['database'] }
    end
  end

  def self.load_static(directory = 'data/')
    p "Loading NUTS static data, Environment: #{Rails.env}"

    CCS.csv_to_nuts_regions directory + 'nuts1_regions.csv', config
    CCS.csv_to_nuts_regions directory + 'nuts2_regions.csv', config
    CCS.csv_to_nuts_regions directory + 'nuts3_regions.csv', config

    p "Finished loading NUTS codes into db #{Rails.application.config.database_configuration[Rails.env]['database']}"
    CCS.csv_to_fm_regions directory + 'facilities_management/regions.csv', config
    p 'Loading FM rates static data'
    CCS.csv_to_fm_rates directory + 'facilities_management/rates.csv', config
  end
end

namespace :db do
  desc 'add NUTS static data to the database'
  task :static do
    p 'Loading NUTS static'
    CCS.load_static
  end

  desc 'add static data to the database'
  task setup: :static do
  end
end
