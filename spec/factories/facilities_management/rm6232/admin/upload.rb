FactoryBot.define do
  factory :facilities_management_rm6232_admin_upload, class: 'FacilitiesManagement::RM6232::Admin::Upload' do
    user
  end

  factory :facilities_management_rm6232_admin_upload_with_upload, parent: :facilities_management_rm6232_admin_upload do
    supplier_details_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_xlsx.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    supplier_services_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_xlsx.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    supplier_regions_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_xlsx.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
  end
end
