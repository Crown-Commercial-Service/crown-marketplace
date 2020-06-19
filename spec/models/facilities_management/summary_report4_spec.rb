require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:procurement_with_buildings) { create(:facilities_management_procurement_with_contact_details_with_buildings) }

  let(:procurement_with_buildings_no_tupe_london) { create(:facilities_management_procurement_with_contact_details_with_buildings_no_tupe_london) }

  include_context 'with list of suppliers'

  context 'when testing DA' do
    it 'create a direct-award report check prices with tupe' do
      report = described_class.new(procurement_with_buildings.id)

      results = {}
      report_results = {}
      supplier_names.each do |supplier_name|
        report_results[supplier_name] = {}
        report.calculate_services_for_buildings supplier_name
        results[supplier_name] = report.direct_award_value
      end

      sorted_list = results.sort_by { |_k, v| v }

      expect(sorted_list.first).to eq [:"Halvorson, Corwin and O'Connell", 3105.6768582048]
    end

    it 'price for one supplier with tupe' do
      report = described_class.new(procurement_with_buildings.id)
      supplier_name = 'Hickle-Schinner'
      report_results = {}
      report_results[supplier_name] = {}
      report.calculate_services_for_buildings supplier_name

      expect(report.direct_award_value.round(2)).to eq 27733.01
    end

    it 'can calculate a direct award procurement no tupe no london' do
      report = described_class.new(procurement_with_buildings_no_tupe_london.id)

      results = {}
      supplier_names.each do |supplier_name|
        results[supplier_name] = {}
        report.calculate_services_for_buildings(supplier_name, true, :da)
        results[supplier_name][:direct_award_value] = report.direct_award_value
      end

      expect(report.direct_award_value).to be > -1
    end
  end
end
