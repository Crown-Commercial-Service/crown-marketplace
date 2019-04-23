require 'rake'
module SupplyTeachers
  module Admin
    class Upload < ApplicationRecord
      include AASM
      self.table_name = "supply_teachers_admin_uploads"

      default_scope { order(created_at: :desc) }

      mount_uploader :current_accredited_suppliers, SupplyTeachersFileUploader
      mount_uploader :geographical_data_all_suppliers, SupplyTeachersFileUploader
      mount_uploader :lot_1_and_lot_2_comparisons, SupplyTeachersFileUploader
      mount_uploader :master_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :neutral_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :pricing_for_tool, SupplyTeachersFileUploader
      mount_uploader :supplier_lookup, SupplyTeachersFileUploader

      attr_accessor :current_accredited_suppliers_cache, :geographical_data_all_suppliers_cache, :lot_1_and_lot_2_comparisons_cache, :master_vendor_contacts_cache, :neutral_vendor_contacts_cache, :pricing_for_tool_cache, :supplier_lookup_cache

      validate :script_data, on: :create

      aasm do
        state :review, initial: true
        state :approved, :rejected, :canceled
        event :approve do
          transitions from: :review, to: :approved
        end
        event :reject do
          after do
            cleanup_input_files
          end
          transitions from: :review, to: :rejected
        end
        event :cancel do
          after do
            cleanup_input_files
          end
          transitions from: :review, to: :canceled
        end

      end

      def cleanup_input_files
        if current_accredited_suppliers.file.present? && self.class.previous_uploaded_file(:current_accredited_suppliers).try(:file).present?
          FileUtils.cp(self.class.previous_uploaded_file(:current_accredited_suppliers).file.path, './lib/tasks/supply_teachers/input/Current_Accredited_Suppliers_.xlsx')
        end
        if geographical_data_all_suppliers.file.present? && self.class.previous_uploaded_file(:geographical_data_all_suppliers).try(:file).present?
          FileUtils.cp(self.class.previous_uploaded_file(:geographical_data_all_suppliers).file.path, './lib/tasks/supply_teachers/input/Geographical Data all suppliers.xlsx')
        end
        if lot_1_and_lot_2_comparisons.file.present? && self.class.previous_uploaded_file(:lot_1_and_lot_2_comparisons).try(:file).present?
          FileUtils.cp(self.class.previous_uploaded_file(:lot_1_and_lot_2_comparisons).file.path, './lib/tasks/supply_teachers/input/Lot_1_and_2_comparisons.xlsx')
        end
        if master_vendor_contacts.file.present? && self.class.previous_uploaded_file(:master_vendor_contacts).try(:file).present?
          FileUtils.cp(self.class.previous_uploaded_file(:master_vendor_contacts).file.path, './lib/tasks/supply_teachers/input/master_vendor_contacts.csv')
        end
        if neutral_vendor_contacts.file.present? && self.class.previous_uploaded_file(:neutral_vendor_contacts).try(:file).present?
          FileUtils.cp(self.class.previous_uploaded_file(:neutral_vendor_contacts).file.path, './lib/tasks/supply_teachers/input/neutral_vendor_contacts.csv')
        end
        if pricing_for_tool.file.present? &&  self.class.previous_uploaded_file(:pricing_for_tool).try(:file).present?
          FileUtils.cp(self.class.previous_uploaded_file(:pricing_for_tool).file.path, './lib/tasks/supply_teachers/input/pricing for tool.xlsx')
        end
        if supplier_lookup.file.present? && self.class.previous_uploaded_file(:supplier_lookup).try(:file).present?
          FileUtils.cp(self.class.previous_uploaded_file(:supplier_lookup).file.path, './lib/tasks/supply_teachers/input/supplier_lookup.csv')
        end
      end

      def self.previous_uploaded_file(attr_name)
        previous_uploaded_file_object(attr_name).try(:send, attr_name)
      end

      def self.previous_uploaded_file_object(attr_name)
        where(aasm_state: :approved).where.not("#{attr_name}": nil).first
      end

      private

      def script_data
        reject_all_uploads_in_review
        copy_files_to_input_folder

        Rake::Task.clear
        Rails.application.load_tasks
        Rake::Task['st:clean'].invoke
        Rake::Task['st:data'].invoke

        unless File.zero?('./lib/tasks/supply_teachers/output/errors.out')
          file = File.open('./lib/tasks/supply_teachers/output/errors.out')
          errors.add(:base, "There is an error with your files: " + file.read)
        end

      rescue StandardError => e
        errors.add(:base, "There is an error with your files. Please try again")
      end

      def copy_files_to_input_folder
        FileUtils.cp(current_accredited_suppliers.file.path, './lib/tasks/supply_teachers/input/Current_Accredited_Suppliers_.xlsx') if current_accredited_suppliers_changed?
        FileUtils.cp(geographical_data_all_suppliers.file.path, './lib/tasks/supply_teachers/input/Geographical Data all suppliers.xlsx') if geographical_data_all_suppliers_changed?
        FileUtils.cp(lot_1_and_lot_2_comparisons.file.path, './lib/tasks/supply_teachers/input/Lot_1_and_2_comparisons.xlsx') if lot_1_and_lot_2_comparisons_changed?
        FileUtils.cp(master_vendor_contacts.file.path, './lib/tasks/supply_teachers/input/master_vendor_contacts.csv') if master_vendor_contacts_changed?
        FileUtils.cp(neutral_vendor_contacts.file.path, './lib/tasks/supply_teachers/input/neutral_vendor_contacts.csv') if neutral_vendor_contacts_changed?
        FileUtils.cp(pricing_for_tool.file.path, './lib/tasks/supply_teachers/input/pricing for tool.xlsx') if pricing_for_tool_changed?
        FileUtils.cp(supplier_lookup.file.path, './lib/tasks/supply_teachers/input/supplier_lookup.csv') if supplier_lookup_changed?
      end

      def reject_all_uploads_in_review
        Upload.review.map(&:cancel!)
      end

    end
  end
end