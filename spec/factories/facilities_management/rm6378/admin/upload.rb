FactoryBot.define do
  factory :facilities_management_rm6378_admin_upload, class: 'FacilitiesManagement::RM6378::Admin::Upload' do
    user { association(:user) }
    framework_id { 'RM6378' }
  end

  factory :facilities_management_rm6378_admin_upload_with_document, parent: :facilities_management_rm6378_admin_upload do
    supplier_details_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_xlsx.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
  end
end
