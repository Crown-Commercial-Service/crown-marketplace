module FacilitiesManagement
  module RM6232
    module Admin
      class ManagementReportWorker
        include Sidekiq::Worker

        sidekiq_options queue: 'fm', retry: false

        def perform(id)
          ManagementReportCsvGenerator.new(id).generate
        end
      end
    end
  end
end
