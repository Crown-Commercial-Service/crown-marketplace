require 'rake'
module SupplyTeachers
  module Admin
    class Upload < ApplicationRecord
      self.table_name = "supply_teachers_admin_uploads"

      mount_uploader :current_accredited_suppliers, SupplyTeachersFileUploader
      mount_uploader :geographical_data_all_suppliers, SupplyTeachersFileUploader
      mount_uploader :lot_1_and_lot_2_comparisons, SupplyTeachersFileUploader
      mount_uploader :master_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :neutral_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :pricing_for_tool, SupplyTeachersFileUploader
      mount_uploader :supplier_lookup, SupplyTeachersFileUploader

      attr_accessor :current_accredited_suppliers_cache, :geographical_data_all_suppliers_cache, :lot_1_and_lot_2_comparisons_cache, :master_vendor_contacts_cache, :neutral_vendor_contacts_cache, :pricing_for_tool_cache, :supplier_lookup_cache

      validate :script_data

      private
      def script_data
        begin
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
    end
  end
end