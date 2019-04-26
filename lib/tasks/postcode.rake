module OrdnanceSurvey

  def self.import_postcodes(file_name)
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

end


namespace :db do
  desc 'add FM postcode data to the database'
  task postcode: :environment do
    p 'Creating postcode database and import'
    p Rails.root
    settings =  ActiveSupport::JSON.decode(File.read(Rails.root+"facilities_management/postcode_settings.json")) if defined?(data)
    OrdnanceSurvey.import_postcodes settings
  end
  # desc 'add postcode static data to the database'
  # task static: :postcode do
  # end
end