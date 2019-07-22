module ManagementConsultancy
  module Admin
    class Upload < ApplicationRecord
      include AASM
      self.table_name = 'management_consultancy_admin_uploads'
      default_scope { order(created_at: :desc) }

      mount_uploader :suppliers_data, ManagementConsultancyFileUploader

      attr_accessor :suppliers_data_cache

      aasm do
        state :in_progress, initial: true
        state :uploaded
        event :upload do
          transitions from: :in_progress, to: :uploaded
        end
        event :fail do
          transitions from: :in_progress, to: :failed
        end
      end

      def short_uuid
        id[0..7]
      end

      private

      def start_upload
        ManagementConsultancy::DataUploadWorker.perform_async(id)
      end
    end
  end
end
