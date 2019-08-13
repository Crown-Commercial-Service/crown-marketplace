RSpec.shared_context 'with fta dates' do
  let(:date_0_months_ago) { Time.zone.today }
  let(:date_1_month_ago) { Time.zone.today - 1.month }
  let(:date_2_months_ago) { Time.zone.today - 2.months }
  let(:date_3_months_ago) { Time.zone.today - 3.months }
  let(:date_4_months_ago) { Time.zone.today - 4.months }
  let(:date_5_months_ago) { Time.zone.today - 5.months }
  let(:date_6_months_ago) { Time.zone.today - 6.months }
  let(:date_7_months_ago) { Time.zone.today - 7.months }
  let(:date_8_months_ago) { Time.zone.today - 8.months }
  let(:date_9_months_ago) { Time.zone.today - 9.months }
  let(:date_10_months_ago) { Time.zone.today - 10.months }
  let(:date_11_months_ago) { Time.zone.today - 11.months }
  let(:date_12_months_ago) { Time.zone.today - 12.months }
  let(:date_13_months_ago) { Time.zone.today - 13.months }
  let(:date_1_month_from_now) { Time.zone.today + 1.month }
end
