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

      validate :run_scripts

      private

      def run_scripts
        require 'rake'
        Rails.application.load_tasks

        Rake::Task['st:clean'].execute

        copy_files_to_input_folder

        Rake::Task['st:data'].invoke

      end

      def copy_files_to_input_folder
        FileUtils.cp(Rails.root.to_s + current_accredited_suppliers_url, './lib/tasks/supply_teachers/input/Current_Accredited_Suppliers_.xlsx') if current_accredited_suppliers_changed?
        FileUtils.cp(Rails.root.to_s + geographical_data_all_suppliers_url, './lib/tasks/supply_teachers/input/Geographical Data all suppliers.xlsx') if geographical_data_all_suppliers_changed?
        FileUtils.cp(Rails.root.to_s + lot_1_and_lot_2_comparisons_url, './lib/tasks/supply_teachers/input/Lot_1_and_2_comparisons.xlsx') if lot_1_and_lot_2_comparisons_changed?
        FileUtils.cp(Rails.root.to_s + master_vendor_contacts_url, './lib/tasks/supply_teachers/input/master_vendor_contacts.csv') if master_vendor_contacts_changed?
        FileUtils.cp(Rails.root.to_s + neutral_vendor_contacts_url, './lib/tasks/supply_teachers/input/neutral_vendor_contacts.csv') if neutral_vendor_contacts_changed?
        FileUtils.cp(Rails.root.to_s + pricing_for_tool_url, './lib/tasks/supply_teachers/input/pricing for tool.xlsx') if pricing_for_tool_changed?
        FileUtils.cp(Rails.root.to_s + supplier_lookup_url, './lib/tasks/supply_teachers/input/supplier_lookup.csv') if supplier_lookup_changed?
      end
    end
  end
end