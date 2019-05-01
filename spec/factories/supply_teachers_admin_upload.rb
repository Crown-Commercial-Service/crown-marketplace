FactoryBot.define do
  factory :supply_teachers_admin_upload, class: SupplyTeachers::Admin::Upload do
    supplier_lookup { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'supplier_lookup_test.csv')) }
  end
end
