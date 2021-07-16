class UpdateModelsInAttachments < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    RECORD_TYPE_CONVERSION.each do |old_record_type, new_record_type|
      ActiveStorage::Attachment.where(record_type: old_record_type).update_all(record_type: new_record_type)
    end
  end

  def down
    RECORD_TYPE_CONVERSION.each do |old_record_type, new_record_type|
      ActiveStorage::Attachment.where(record_type: new_record_type).update_all(record_type: old_record_type)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations

  RECORD_TYPE_CONVERSION = { 'FacilitiesManagement::Admin::ManagementReport' => 'FacilitiesManagement::RM3830::Admin::ManagementReport',
                             'FacilitiesManagement::SpreadsheetImport' => 'FacilitiesManagement::RM3830::SpreadsheetImport',
                             'FacilitiesManagement::ProcurementSupplier' => 'FacilitiesManagement::RM3830::ProcurementSupplier',
                             'FacilitiesManagement::Admin::Upload' => 'FacilitiesManagement::RM3830::Admin::Upload',
                             'FacilitiesManagement::Procurement' => 'FacilitiesManagement::RM3830::Procurement' }.freeze
end
