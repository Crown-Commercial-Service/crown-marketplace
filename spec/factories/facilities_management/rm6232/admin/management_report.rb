FactoryBot.define do
  factory :facilities_management_rm6232_admin_management_report, class: 'FacilitiesManagement::RM6232::Admin::ManagementReport' do
    start_date  { Time.zone.today - 1.year }
    end_date    { Time.zone.today }
  end

  factory :facilities_management_rm6232_admin_management_report_with_report, parent: :facilities_management_rm6232_admin_management_report do
    management_report_csv { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_csv.csv'), 'text/csv') }
  end
end
