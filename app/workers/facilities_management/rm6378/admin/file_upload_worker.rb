module FacilitiesManagement
  module RM6378
    module Admin
      class FileUploadWorker < ::Admin::FileUploadWorker
        sidekiq_options queue: 'fm', retry: false
      end
    end
  end
end
