module LegalServices
  module Admin
    class Upload < ApplicationRecord
      include AASM
      self.table_name = 'legal_services_admin_uploads'
      default_scope { order(created_at: :desc) }

      SUPPLIERS_PATH = Rails.root.join('storage', 'legal_consultancy', 'current_data', 'input', 'Suppliers.xlsx').freeze
      SUPPLIER_SERVICE_OFFERINGS_PATH = Rails.root.join('storage', 'legal_services', 'current_data', 'input', 'Service offerings.xlsx').freeze
      SUPPLIER_REGIONAL_OFFERINGS_PATH = Rails.root.join('storage', 'legal_services', 'current_data', 'input', 'Regional offerings.xlsx').freeze
      RATE_CARDS_PATH = Rails.root.join('storage', 'legal_services', 'current_data', 'input', 'rate_cards.xlsx').freeze

      ATTRIBUTES = %i[suppliers].freeze

      mount_uploader :suppliers, LegalServicesFileUploader
      mount_uploader :rate_cards, LegalServicesFileUploader
      mount_uploader :supplier_service_offerings, LegalServicesFileUploader
      mount_uploader :supplier_regional_offerings, LegalServicesFileUploader

      attr_accessor :suppliers_cache, :rate_cards_cache, :supplier_service_offerings_cache, :supplier_regional_offerings_cache

      validate :reject_uploads_and_cp_files, on: :create

      aasm do
        state :in_progress, initial: true
        state :in_review, :failed, :approved, :rejected, :canceled, :uploading
        event :review do
          transitions from: :in_progress, to: :in_review
        end
        event :fail do
          after :cleanup_input_files
          transitions from: %i[in_progress uploading], to: :failed
        end
        event :upload do
          after :start_upload
          transitions from: :in_review, to: :uploading
        end
        event :approve do
          transitions from: :uploading, to: :approved
        end
        event :reject do
          after :cleanup_input_files
          transitions from: :in_review, to: :rejected
        end
        event :cancel do
          after :cleanup_input_files
          transitions from: %i[in_review in_progress], to: :canceled
        end
      end

      def cleanup_input_files
        cp_previous_uploaded_file(:suppliers, SUPPLIERS_PATH)
        cp_previous_uploaded_file(:supplier_service_offerings, SUPPLIER_SERVICE_OFFERINGS_PATH)
        cp_previous_uploaded_file(:supplier_regional_offerings, SUPPLIER_REGIONAL_OFFERINGS_PATH)
        cp_previous_uploaded_file(:rate_cards, RATE_CARDS_PATH)
      end

      def files_count
        count = 0
        [suppliers, supplier_service_offerings, supplier_regional_offerings, rate_cards].each do |uploaded_file|
          count += 1 if uploaded_file.file.present?
        end
        count
      end

      def short_uuid
        id[0..7]
      end

      def self.previous_uploaded_file(attr_name)
        previous_uploaded_file_object(attr_name).try(:send, attr_name)
      end

      def self.previous_uploaded_file_object(attr_name)
        where(aasm_state: :approved).where.not("#{attr_name}": nil).first
      end

      def self.in_review_or_in_progress?
        in_review.any? || in_progress.any?
      end

      private

      def start_upload
        LegalServices::DataUploadWorker.perform_async(id)
      end

      def reject_uploads_and_cp_files
        reject_previous_uploads
        copy_files_to_input_folder
      rescue StandardError => e
        errors.add(:base, 'There is an error with your files. Please try again: ' + e.message)
      end

      def copy_files_to_input_folder
        FileUtils.makedirs(Rails.root.join('storage', 'legal_services', 'current_data', 'input'))
        cp_file_to_input(suppliers.file.try(:path), SUPPLIERS_PATH, suppliers_changed?)
        cp_file_to_input(supplier_service_offerings.file.try(:path), SUPPLIER_SERVICE_OFFERINGS_PATH, supplier_service_offerings_changed?)
        cp_file_to_input(supplier_regional_offerings.file.try(:path), SUPPLIER_REGIONAL_OFFERINGS_PATH, supplier_regional_offerings_changed?)
        cp_file_to_input(rate_cards.file.try(:path), RATE_CARDS_PATH, rate_cards_changed?)
      end

      def cp_file_to_input(file_path, new_path, condition)
        if Rails.env.development?
          FileUtils.cp(file_path, new_path) if condition
        else
          object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
          object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path(new_path)).upload_file(file_path, acl: 'public-read')
        end
      end

      def s3_path(path)
        path.slice((path.index('storage/') + 8)..path.length)
      end

      def reject_previous_uploads
        self.class.in_review.map(&:cancel!)
        self.class.in_progress.map(&:cancel!)
      end

      def cp_previous_uploaded_file(attr_name, file_path)
        return unless available_for_cp(attr_name)

        cp_file_to_input(self.class.previous_uploaded_file(attr_name).file.path, file_path, true)
      end

      def available_for_cp(attr_name)
        send(attr_name).file.present? && self.class.previous_uploaded_file(attr_name).try(:file).present?
      end
    end
  end
end
