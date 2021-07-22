module FacilitiesManagement
  module Admin
    class Upload < ApplicationRecord
      include AASM

      self.table_name = 'facilities_management_admin_uploads'
      serialize :import_errors, Array

      has_one_attached :supplier_data_file

      validate :supplier_data_file_attached, :supplier_data_file_ext_validation, on: :upload
      validates :supplier_data_file, antivirus: { message: :malicious }, size: { less_than: 10.megabytes, message: :too_large }, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: :wrong_content_type }, on: :upload

      aasm do
        state :not_started, initial: true
        state :in_progress
        state :checking_file
        state :processing_file
        state :checking_processed_data
        state :publishing_data
        state :published
        state :failed
        event :start_upload do
          transitions from: :not_started, to: :in_progress
          after do
            FacilitiesManagement::FileUploadWorker.perform_async(id)
          end
        end
        event :check_file do
          transitions from: :in_progress, to: :checking_file
        end
        event :process_file do
          transitions from: :checking_file, to: :processing_file
        end
        event :check_processed_data do
          transitions from: :processing_file, to: :checking_processed_data
        end
        event :publish_data do
          transitions from: :checking_processed_data, to: :publishing_data
        end
        event :publish do
          transitions from: :publishing_data, to: :published
        end
        event :fail do
          transitions from: %i[not_started in_progress checking_file processing_file checking_processed_data publishing_data published], to: :failed
        end
      end

      def short_uuid
        id[0..7]
      end

      def self.latest_upload
        published.order(created_at: :desc).first
      end

      private

      def supplier_data_file_attached
        errors.add(:supplier_data_file, :not_attached) unless supplier_data_file.attached?
      end

      def supplier_data_file_ext_validation
        return unless supplier_data_file.attached?

        errors.add(:supplier_data_file, :wrong_extension) unless supplier_data_file.blob.filename.to_s.end_with?('.xlsx')
      end
    end
  end
end
