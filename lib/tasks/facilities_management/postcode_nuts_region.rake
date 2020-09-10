require 'csv'
require 'json'
namespace :db do
  desc 'import postcode and nuts region data which matches postcode to a region code'
  task run_postcodes_to_nuts: :environment do
    DistributedLocks.distributed_lock(152) do
      Dir.entries(Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS')).reject { |f| File.directory? f }.each do |filename|
        data_file = Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS', filename)
        puts "Starting PostodesNutsRegions import for #{filename}"
        file = File.read(data_file)
        data = CSV.parse(file, converters: [->(field, _) { field.delete(' ') }])
        PostcodesNutsRegion.import! %i[postcode code], data, on_duplicate_key_ignore: true
        puts "PostcodesNutsRegions import done for #{filename}"
      end
    end
  end
end
