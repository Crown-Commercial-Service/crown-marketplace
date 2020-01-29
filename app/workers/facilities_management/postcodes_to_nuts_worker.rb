module FacilitiesManagement
  class PostcodesToNutsWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: false, backtrace: 20

    def perform(data_file)
      logger.info 'Starting PostodesNutsRegions import'
      CSV.foreach(data_file) do |row|
        logger.info "Importing #{row}"
        ActiveRecord::Base.connection.execute("INSERT into postcodes_nuts_regions (postcode, code, created_at, updated_at) values('" + row[0].delete(' ') + "', '" + row[1] + "', NOW(), NOW())")
      end
    end
  end
end
