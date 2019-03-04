module CCS
  require 'pg'
  require 'csv'

  def self.csv_to_nuts_regions(file_name, db_name)
    db = PG.connect(dbname: db_name)
    db.exec 'create table IF NOT EXISTS nuts_regions ' \
            '(code varchar(255) UNIQUE, name varchar(255), ' \
            ' nuts1_code varchar(255), nuts2_code varchar(255) );'
    CSV.read(file_name, headers: true).each do |row|
      column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
      values = row.fields.map { |i| "'#{i}'" }.join(',')
      db.exec "DELETE FROM nuts_regions where code = '" + row['code'] + "' ; " \
              'insert into nuts_regions ( ' + column_names + ') values (' + values + ')'
    end
  rescue PG::Error => e
    puts e.message
  ensure
    db&.close
  end

  def self.csv_to_fm_regions(file_name, db_name)
    db = PG.connect(dbname: db_name)
    db.exec <<-SQL
        create table IF NOT EXISTS fm_regions (
          code varchar(255) UNIQUE, name varchar(255) );
    SQL
    CSV.read(file_name, headers: true).each do |row|
      column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
      values = row.fields.map { |i| "'#{i}'" }.join(',')
      db.exec "DELETE FROM fm_regions where code = '" + row['code'] + "' ; " \
              'insert into fm_regions ( ' + column_names + ') values (' + values + ')'
    end
  rescue PG::Error => e
    puts e.message
  ensure
    db&.close
  end

  def self.load_static(directory = 'data/', db_name = 'marketplace_' + Rails.env)
    p 'Version of libpg: ' + PG.library_version.to_s
    p 'Loading NUTS static data'
    p "Environment: #{Rails.env}"

    file1 = directory + 'nuts1_regions.csv'
    file2 = directory + 'nuts2_regions.csv'
    file3 = directory + 'nuts3_regions.csv'

    CCS.csv_to_nuts_regions file1, db_name
    CCS.csv_to_nuts_regions file2, db_name
    CCS.csv_to_nuts_regions file3, db_name

    p "Finished loading NUTS codes into db #{db_name}"
    p
    p 'Loading FM regions static data'
    file4 = directory + 'facilities_management/regions.csv'
    CCS.csv_to_fm_regions file4, db_name
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
