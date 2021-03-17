FactoryBot.define do
  factory :facilities_management_admin_management_report, class: 'FacilitiesManagement::Admin::ManagementReport' do
    start_date  { Time.zone.today - 1.year }
    end_date    { Time.zone.today }
  end
end
