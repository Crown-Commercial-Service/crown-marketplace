module FacilitiesManagement
  class PostcodesToNutsWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'fm', retry: false, backtrace: 20

    def perform(data_file)
      logger.info "Starting PostodesNutsRegions import for #{data_file}"
      file = File.read(data_file)
      data = CSV.parse(file, converters: [->(field, _) { field.delete(' ') }])
      PostcodesNutsRegion.import! %i[postcode code], data, on_duplicate_key_ignore: true
      logger.info "PostcodesNutsRegions import done for #{data_file}"
    end
  end
end
