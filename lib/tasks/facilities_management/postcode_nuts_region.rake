require 'csv'
require 'json'

namespace :db do
  desc 'import postcode and nuts region data which matches postcode to a region code'
  task importpostcoderegion: :environment do
    p 'Truncate table postcodes_nuts_regions'
    PostcodesNutsRegions.delete_all
    postcode_regions = []
    columns = %i[postcode code]
    CSV.foreach('data/facilities_management/pc_uk_NUTS-2013_vFM-CAT.csv') do |row|
      p row[0].delete(' ') + '  ' + row[1]
      postcode_regions << PostcodesNutsRegions.new(postcode: row[0].delete(' '), code: row[1])
    end
    p 'Importing records into database table postcodes_nuts_regions'
    PostcodesNutsRegions.import columns, postcode_regions
    p 'Finished importing records into database table postcodes_nuts_regions'
  end
end
