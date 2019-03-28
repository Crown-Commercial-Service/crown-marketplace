module CCS
  require 'pg'
  require 'csv'

  def self.csv_to_fm_rates(file_name, db_config)

    db = PG.connect(db_config)
    query = 'create table IF NOT EXISTS fm_rates (code varchar(5) UNIQUE, framework varchar(10), benchmark varchar(10));'
    db.query query
    CSV.read(file_name, headers: true).each do |row|
      puts "row"
      puts row
      column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
      puts "column_names"
      puts column_names
      values = row.fields.map { |i| "'#{i}'" }.join(',')
      puts "values"
      puts values
      query = "DELETE FROM fm_rates where code = '" + row['code'] + "' ; " \
              'insert into fm_rates ( ' + column_names + ') values (' + values + ')'
      puts "query"
      puts query
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

  def self.load_static2(directory = 'data/')
    p "Environment: #{Rails.env}"

    p 'Loading FM rates static data'
    CCS.csv_to_fm_rates directory + 'facilities_management/rates.csv', config
  end
end

namespace :db do
  desc 'add RATES static data to the database'
  task :static2 do
    CCS.load_static2
  end
  end
