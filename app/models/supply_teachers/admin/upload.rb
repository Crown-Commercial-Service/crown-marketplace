module SupplyTeachers
  module Admin
    class Upload < ApplicationRecord
      include AASM
      self.table_name = 'supply_teachers_admin_uploads'
      default_scope { order(created_at: :desc) }

      CURRENT_ACCREDITED_PATH = './lib/tasks/supply_teachers/input/Current_Accredited_Suppliers_.xlsx'.freeze
      GEOGRAPHICAL_DATA_PATH = './lib/tasks/supply_teachers/input/Geographical Data all suppliers.xlsx'.freeze
      LOT_1_AND_LOT2_PATH = './lib/tasks/supply_teachers/input/Lot_1_and_2_comparisons.xlsx'.freeze
      MASTER_VENDOR_PATH = './lib/tasks/supply_teachers/input/master_vendor_contacts.csv'.freeze
      NEUTRAL_VENDOR_PATH = './lib/tasks/supply_teachers/input/neutral_vendor_contacts.csv'.freeze
      PRICING_TOOL_PATH = './lib/tasks/supply_teachers/input/pricing for tool.xlsx'.freeze
      SUPPLIER_LOOKUP_PATH = './lib/tasks/supply_teachers/input/supplier_lookup.csv'.freeze

      mount_uploader :current_accredited_suppliers, SupplyTeachersFileUploader
      mount_uploader :geographical_data_all_suppliers, SupplyTeachersFileUploader
      mount_uploader :lot_1_and_lot_2_comparisons, SupplyTeachersFileUploader
      mount_uploader :master_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :neutral_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :pricing_for_tool, SupplyTeachersFileUploader
      mount_uploader :supplier_lookup, SupplyTeachersFileUploader

      attr_accessor :current_accredited_suppliers_cache, :geographical_data_all_suppliers_cache, :lot_1_and_lot_2_comparisons_cache, :master_vendor_contacts_cache, :neutral_vendor_contacts_cache, :pricing_for_tool_cache, :supplier_lookup_cache

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

      def self.previous_uploaded_file(attr_name)
        previous_uploaded_file_object(attr_name).try(:send, attr_name)
      end

      def self.previous_uploaded_file_object(attr_name)
        where(aasm_state: :approved).where.not("#{attr_name}": nil).first
      end

      private

      def start_upload
        SupplyTeachers::DataUploadWorker.perform_async(id)
      end

      def reject_uploads_and_cp_files
        reject_previous_uploads
        copy_files_to_input_folder
      rescue StandardError => e
        errors.add(:base, 'There is an error with your files. Please try again: ' + e.message)
      end

      # rubocop:disable Metrics/AbcSize
      def copy_files_to_input_folder
        cp_file_to_input(current_accredited_suppliers.file.try(:path), CURRENT_ACCREDITED_PATH, current_accredited_suppliers_changed?)
        cp_file_to_input(geographical_data_all_suppliers.file.try(:path), GEOGRAPHICAL_DATA_PATH, geographical_data_all_suppliers_changed?)
        cp_file_to_input(lot_1_and_lot_2_comparisons.file.try(:path), LOT_1_AND_LOT2_PATH, lot_1_and_lot_2_comparisons_changed?)
        cp_file_to_input(master_vendor_contacts.file.try(:path), MASTER_VENDOR_PATH, master_vendor_contacts_changed?)
        cp_file_to_input(neutral_vendor_contacts.file.try(:path), NEUTRAL_VENDOR_PATH, neutral_vendor_contacts_changed?)
        cp_file_to_input(pricing_for_tool.file.try(:path), PRICING_TOOL_PATH, pricing_for_tool_changed?)
        cp_file_to_input(supplier_lookup.file.try(:path), SUPPLIER_LOOKUP_PATH, supplier_lookup_changed?)
      end
      # rubocop:enable Metrics/AbcSize

      def cp_file_to_input(file_path, new_path, condition)
        FileUtils.cp(file_path, new_path) if condition
      end

      def reject_previous_uploads
        self.class.in_review.map(&:cancel!)
        self.class.in_progress.map(&:cancel!)
      end

      def cp_previous_uploaded_file(attr_name, file_path)
        FileUtils.cp(self.class.previous_uploaded_file(attr_name).file.path, file_path) if available_for_cp(attr_name)
      end

      def available_for_cp(attr_name)
        send(attr_name).file.present? && self.class.previous_uploaded_file(attr_name).try(:file).present?
      end
    end
  end
end
