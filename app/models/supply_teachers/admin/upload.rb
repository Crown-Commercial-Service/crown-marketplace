module SupplyTeachers
  module Admin
    class Upload < ApplicationRecord
      include AASM
      self.table_name = 'supply_teachers_admin_uploads'
      default_scope { order(created_at: :desc) }

      CURRENT_ACCREDITED_PATH = Rails.root.join('storage', 'supply_teachers', 'current_data', 'input', 'current_accredited_suppliers.xlsx').freeze
      GEOGRAPHICAL_DATA_PATH = Rails.root.join('storage', 'supply_teachers', 'current_data', 'input', 'geographical_data_all_suppliers.xlsx').freeze
      LOT_1_AND_LOT2_PATH = Rails.root.join('storage', 'supply_teachers', 'current_data', 'input', 'lot_1_and_2_comparisons.xlsx').freeze
      MASTER_VENDOR_PATH = Rails.root.join('storage', 'supply_teachers', 'current_data', 'input', 'master_vendor_contacts.csv').freeze
      NEUTRAL_VENDOR_PATH = Rails.root.join('storage', 'supply_teachers', 'current_data', 'input', 'neutral_vendor_contacts.csv').freeze
      PRICING_TOOL_PATH = Rails.root.join('storage', 'supply_teachers', 'current_data', 'input', 'pricing_for_tool.xlsx').freeze
      SUPPLIER_LOOKUP_PATH = Rails.root.join('storage', 'supply_teachers', 'current_data', 'input', 'supplier_lookup.csv').freeze
      ATTRIBUTES = %i[current_accredited_suppliers geographical_data_all_suppliers lot_1_and_lot_2_comparisons master_vendor_contacts neutral_vendor_contacts pricing_for_tool supplier_lookup].freeze

      mount_uploader :current_accredited_suppliers, SupplyTeachersFileUploader
      mount_uploader :geographical_data_all_suppliers, SupplyTeachersFileUploader
      mount_uploader :lot_1_and_lot_2_comparisons, SupplyTeachersFileUploader
      mount_uploader :master_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :neutral_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :pricing_for_tool, SupplyTeachersFileUploader
      mount_uploader :supplier_lookup, SupplyTeachersFileUploader

      attr_accessor :current_accredited_suppliers_cache, :geographical_data_all_suppliers_cache, :lot_1_and_lot_2_comparisons_cache, :master_vendor_contacts_cache, :neutral_vendor_contacts_cache, :pricing_for_tool_cache, :supplier_lookup_cache

      validate :any_present?, on: :create
      validate :reject_uploads_and_cp_files, on: :create

      aasm do
        state :in_progress, initial: true
        state :in_review, :failed, :approved, :rejected, :canceled, :uploading
        event :review do
          transitions from: :in_progress, to: :in_review
        end
        event :fail do
          transitions from: %i[in_progress uploading], to: :failed, after: :cleanup_input_files
        end
        event :upload do
          transitions from: :in_review, to: :uploading
        end
        event :approve do
          transitions from: :uploading, to: :approved
        end
        event :reject do
          transitions from: :in_review, to: :rejected, after: :cleanup_input_files
        end
        event :cancel do
          transitions from: %i[in_review in_progress], to: :canceled, after: :cleanup_input_files
        end
      end

      def cleanup_input_files
        cp_previous_uploaded_file(:current_accredited_suppliers, CURRENT_ACCREDITED_PATH)
        cp_previous_uploaded_file(:geographical_data_all_suppliers, GEOGRAPHICAL_DATA_PATH)
        cp_previous_uploaded_file(:lot_1_and_lot_2_comparisons, LOT_1_AND_LOT2_PATH)
        cp_previous_uploaded_file(:master_vendor_contacts, MASTER_VENDOR_PATH)
        cp_previous_uploaded_file(:neutral_vendor_contacts, NEUTRAL_VENDOR_PATH)
        cp_previous_uploaded_file(:pricing_for_tool, PRICING_TOOL_PATH)
        cp_previous_uploaded_file(:supplier_lookup, SUPPLIER_LOOKUP_PATH)
      end

      def files_count
        count = 0
        [current_accredited_suppliers, geographical_data_all_suppliers, lot_1_and_lot_2_comparisons, master_vendor_contacts, neutral_vendor_contacts, pricing_for_tool, supplier_lookup].each do |uploaded_file|
          count += 1 if uploaded_file.file.present?
        end
        count
      end

      def datetime
        created_at.strftime('%d %b %Y at %l:%M%P')
      end

      def self.previous_uploaded_file(attr_name)
        previous_uploaded_file_object(attr_name).try(:send, attr_name)
      end

      def self.previous_uploaded_file_url(attr_name)
        previous_uploaded_file(attr_name).path
      end

      def self.previous_uploaded_file_object(attr_name)
        where(aasm_state: :approved).where.not("#{attr_name}": nil).first
      end

      def self.in_review_or_in_progress
        in_review + in_progress
      end

      def self.perform_upload(upload_id)
        upload_session = find(upload_id)
        upload_session.upload!
        SupplyTeachers::DataUploadWorker.perform_async(upload_id)
        upload_session
      end

      private

      def any_present?
        errors.add :base, :none_present unless ATTRIBUTES.any? { |attr| send(attr).try(:present?) }
      end

      def reject_uploads_and_cp_files
        return if errors.any?

        reject_previous_uploads
        copy_files_to_input_folder
      rescue StandardError => e
        errors.add(:base, e.message)
      end

      def copy_files_to_input_folder
        FileUtils.makedirs(Rails.root.join('storage', 'supply_teachers', 'current_data', 'input'))
        cp_file_to_input(current_accredited_suppliers_url, CURRENT_ACCREDITED_PATH, current_accredited_suppliers_changed?)
        cp_file_to_input(geographical_data_all_suppliers_url, GEOGRAPHICAL_DATA_PATH, geographical_data_all_suppliers_changed?)
        cp_file_to_input(lot_1_and_lot_2_comparisons_url, LOT_1_AND_LOT2_PATH, lot_1_and_lot_2_comparisons_changed?)
        cp_file_to_input(master_vendor_contacts_url, MASTER_VENDOR_PATH, master_vendor_contacts_changed?)
        cp_file_to_input(neutral_vendor_contacts_url, NEUTRAL_VENDOR_PATH, neutral_vendor_contacts_changed?)
        cp_file_to_input(pricing_for_tool_url, PRICING_TOOL_PATH, pricing_for_tool_changed?)
        cp_file_to_input(supplier_lookup_url, SUPPLIER_LOOKUP_PATH, supplier_lookup_changed?)
      end

      def cp_file_to_input(file_path, new_path, condition)
        return unless condition

        if Rails.env.development?
          FileUtils.cp(file_path, new_path)
        else
          object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
          object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(s3_path(new_path.to_s)).upload_file(file_path, acl: 'public-read')
        end
      end

      def s3_path(path)
        path.slice((path.index('storage/') + 8)..path.length)
      end

      def reject_previous_uploads
        self.class.in_review.map(&:cancel!)
      end

      def cp_previous_uploaded_file(attr_name, file_path)
        return unless available_for_cp(attr_name)

        cp_file_to_input(self.class.previous_uploaded_file_url(attr_name), file_path, true)
      end

      def available_for_cp(attr_name)
        send(attr_name).file.present? && self.class.previous_uploaded_file(attr_name).try(:file).present?
      end
    end
  end
end
