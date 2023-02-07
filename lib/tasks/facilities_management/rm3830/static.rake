module CCS
  def self.csv_to_fm_rates(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.query 'DELETE FROM facilities_management_rm3830_rates'
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| "\"#{i}\"" }.join(',')
        values = row.fields.map { |i| i.blank? ? 'null' : "'#{i}'" }.join(',')
        query = "insert into facilities_management_rm3830_rates ( #{column_names}) values (#{values})"
        db.query query
      end
    end
  rescue PG::Error => e
    puts e.message
  end
end

namespace :db do
  namespace :rm3830 do
    desc 'add FM rates to the database'
    task fm_rates: :environment do
      p 'Loading FM rates static data'
      CCS.csv_to_fm_rates 'data/facilities_management/rm3830/rates.csv'
    end
  end

  desc 'add FM rates to the database'
  task static: :'rm3830:fm_rates'
end
