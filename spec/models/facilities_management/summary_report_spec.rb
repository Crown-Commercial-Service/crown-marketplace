require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  # before do
  # end

  let(:start_date) { Time.zone.today + 1 }
  let(:data) do
    {
      'posted_locations' => ['UKC1', 'UKC2'],
      posted_services: ['C.21', 'C.15', 'C.10', 'C.11', 'C.14', 'C.3', 'C.4', 'C.13', 'C.7', 'C.5', 'C.20', 'C.17', 'C.1', 'C.18', 'C.9', 'C.8', 'C.6', 'C.22', 'C.12', 'C.16', 'C.2', 'C.19', 'D.6', 'D.1', 'D.5', 'D.3', 'D.4', 'D.2', 'E.1', 'E.9', 'E.5', 'E.6', 'E.7', 'E.8', 'E.4', 'E.3', 'E.2', 'F.1', 'F.2', 'F.3', 'F.4', 'F.5', 'F.6', 'F.7', 'F.8', 'F.9', 'F.10', 'G.8', 'G.13', 'G.5', 'G.2', 'G.4', 'G.10', 'G.11', 'G.16', 'G.14', 'G.3', 'G.15', 'G.9', 'G.1', 'G.12', 'G.7', 'G.6', 'H.16', 'H.9', 'H.12', 'H.7', 'H.3', 'H.10', 'H.4', 'H.2', 'H.1', 'H.5', 'H.15', 'H.6', 'H.13', 'H.8', 'H.11', 'H.14', 'I.3', 'I.1', 'I.2', 'I.4', 'J.8', 'J.2', 'J.3', 'J.4', 'J.9', 'J.10', 'J.11', 'J.6', 'J.1', 'J.5', 'J.12', 'J.7', 'K.1', 'K.5', 'K.7', 'K.2', 'K.4', 'K.6', 'K.3', 'L.1', 'L.2', 'L.3', 'L.4', 'L.5', 'L.6', 'L.7', 'L.8', 'L.9', 'L.10', 'L.11', 'M.1', 'N.1', 'O.1'],
      locations: "('\"UKC1\"','\"UKC2\"')",
      services: "('\"C.21\"','\"C.15\"','\"C.10\"','\"C.11\"','\"C.14\"','\"C.3\"','\"C.4\"','\"C.13\"','\"C.7\"','\"C.5\"','\"C.20\"','\"C.17\"','\"C.1\"','\"C.18\"','\"C.9\"','\"C.8\"','\"C.6\"','\"C.22\"','\"C.12\"','\"C.16\"','\"C.2\"','\"C.19\"','\"D.6\"','\"D.1\"','\"D.5\"','\"D.3\"','\"D.4\"','\"D.2\"','\"E.1\"','\"E.9\"','\"E.5\"','\"E.6\"','\"E.7\"','\"E.8\"','\"E.4\"','\"E.3\"','\"E.2\"','\"F.1\"','\"F.2\"','\"F.3\"','\"F.4\"','\"F.5\"','\"F.6\"','\"F.7\"','\"F.8\"','\"F.9\"','\"F.10\"','\"G.8\"','\"G.13\"','\"G.5\"','\"G.2\"','\"G.4\"','\"G.10\"','\"G.11\"','\"G.16\"','\"G.14\"','\"G.3\"','\"G.15\"','\"G.9\"','\"G.1\"','\"G.12\"','\"G.7\"','\"G.6\"','\"H.16\"','\"H.9\"','\"H.12\"','\"H.7\"','\"H.3\"','\"H.10\"','\"H.4\"','\"H.2\"','\"H.1\"','\"H.5\"','\"H.15\"','\"H.6\"','\"H.13\"','\"H.8\"','\"H.11\"','\"H.14\"','\"I.3\"','\"I.1\"','\"I.2\"','\"I.4\"','\"J.8\"','\"J.2\"','\"J.3\"','\"J.4\"','\"J.9\"','\"J.10\"','\"J.11\"','\"J.6\"','\"J.1\"','\"J.5\"','\"J.12\"','\"J.7\"','\"K.1\"','\"K.5\"','\"K.7\"','\"K.2\"','\"K.4\"','\"K.6\"','\"K.3\"','\"L.1\"','\"L.2\"','\"L.3\"','\"L.4\"','\"L.5\"','\"L.6\"','\"L.7\"','\"L.8\"','\"L.9\"','\"L.10\"','\"L.11\"','\"M.1\"','\"N.1\"','\"O.1\"')",
      start_date: start_date
    }
  end

  # after do
  # end

  # context 'when condition' do
  #   it 'succeeds' do
  #     pending 'Not implemented'
  #   end
  # end

  it 'creates summary report' do
    report = FacilitiesManagement::SummaryReport.new(start_date, 'test@example.com', data)

    rates = CCS::FM::Rate.read_benchmark_rates

    report.calculate_services_for_buildings rates

    # report.workout_current_lot
    p report.assessed_value
  end

  # rubocop:disable RSpec/ExampleLength
  it 'can calculate prices' do
    # eligible = true if @building_type == 'STANDARD' && (@service_standard == 'A' || @service_standard.nil?) && @priced_at_framework.to_s == 'true' && Integer(@assessed_value) <= 1500000

    rates = CCS::FM::Rate.read_benchmark_rates

    sum_uom = 0
    sum_benchmark = 0

    contract_length_years = 7
    code = 'A1'
    uom_value = 100
    occupants = 0
    tupe_flag = 'N'
    london_flag = 'N'
    cafm_flag = 'Y'
    helpdesk_flag = 'Y'

    calc_fm = FMCalculator::Calculator.new(rates, contract_length_years, code, uom_value, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
    sum_uom += calc_fm.sumunitofmeasure
    sum_benchmark += calc_fm.benchmarkedcostssum

    {
      sum_uom: sum_uom,
      sum_benchmark: sum_benchmark
    }
  end
  # rubocop:enable RSpec/ExampleLength
end
