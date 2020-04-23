require 'csv'
require 'json'

namespace :db do
  desc 'import postcode and nuts region data which matches postcode to a region code'
  task update_postcodes_to_nuts_now: :environment do
    Dir.entries(Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS')).reject { |f| File.directory? f }.sort.reverse.each do |filename|
      p "Starting task for: #{filename}"
      path_name = Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS', filename)
      insert_statement = <<~SQL
        insert into postcodes_nuts_regions (postcode, code)
        values ( '$1', '$2' )
        on conflict (postcode)
        do nothing;
      SQL
      connection = ActiveRecord::Base.connection
      row_counter = 0
      CSV.foreach(path_name) do |row|
        p "Importing #{row}, #{row_counter}" if row_counter.zero? || (row_counter % 10000).zero?
        connection.execute(insert_statement.sub('$1', row[0].delete(' ')).sub('$2', row[1]))
        row_counter += 1
      end
    end
  end
  task run_postcodes_to_nuts_worker: :environment do
    Sidekiq::Queue.new('fm').clear # clear previous jobs before starting new one
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE postcodes_nuts_regions;')
    Dir.entries(Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS')).reject { |f| File.directory? f }.each do |filename|
      p "Starting task for: #{filename}"
      FacilitiesManagement::PostcodesToNutsWorker.perform_async(Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS', filename))
    end
  end
end
