FactoryBot.define do
  factory :supply_teachers_admin_current_data, class: SupplyTeachers::Admin::CurrentData do
    supplier_lookup { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'supplier_lookup_test.csv')) }
  end
end
