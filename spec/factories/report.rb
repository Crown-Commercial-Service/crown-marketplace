FactoryBot.define do
  factory :report, class: 'Report' do
    start_date  { Time.zone.today - 1.year }
    end_date    { Time.zone.today }

    user { association(:user) }

    after(:build) do |report, evaluator|
      report.framework ||= evaluator.framework || create(:framework)
    end

    trait :with_report do
      report_csv { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_csv.csv'), 'text/csv') }
    end
  end
end
