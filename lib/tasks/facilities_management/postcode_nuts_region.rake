require 'csv'
require 'json'

namespace :db do
  desc 'import postcode and nuts region data which matches postcode to a region code'
  task run_postcodes_to_nuts_worker: :environment do
    Sidekiq::Queue.new('fm').clear # clear previous jobs before starting new one
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE postcodes_nuts_regions;')
    Dir.entries(Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS')).reject { |f| File.directory? f }.each do |filename|
      p "Starting task for: #{filename}"
      FacilitiesManagement::PostcodesToNutsWorker.perform_async(Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS', filename))
    end
  end
end
