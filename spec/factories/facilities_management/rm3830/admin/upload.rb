FactoryBot.define do
  factory :facilities_management_rm3830_admin_upload, class: 'FacilitiesManagement::RM3830::Admin::Upload'

  factory :facilities_management_rm3830_admin_upload_with_upload, parent: :facilities_management_rm3830_admin_upload do
    supplier_data_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_xlsx.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
  end
end
