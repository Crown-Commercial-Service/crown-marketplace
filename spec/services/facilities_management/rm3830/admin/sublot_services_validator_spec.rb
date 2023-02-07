require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SublotServicesValidator do
  let(:validator) { described_class.new(params, latest_rate_card, prices, discounts, variance) }
  let(:supplier_id) { FacilitiesManagement::RM3830::Admin::SuppliersAdmin.find_by(supplier_name: 'Abernathy and Sons').supplier_id.to_sym }

  describe '.save' do
    let(:params) { ActionController::Parameters.new(data: data, rate: rate) }
    let(:latest_rate_card) { FacilitiesManagement::RM3830::RateCard.latest }
    let(:prices) { latest_rate_card[:data][:Prices][supplier_id].deep_stringify_keys! }
    let(:discounts) { latest_rate_card[:data][:Discounts][supplier_id].deep_stringify_keys! }
    let(:variance) { latest_rate_card[:data][:Variances][supplier_id] }
    let(:rate_card) { FacilitiesManagement::RM3830::RateCard.latest }

    context 'when the data and rates are valid' do
      let(:data) { { 'E.2': { 'Direct Award Discount (%)': '0.3', 'Restaurant and Catering Facilities (£)': '0.406' }, 'H.5': { 'Direct Award Discount (%)': '0.0', 'Pre-School (£)': '8.513' }, 'M.1': { 'Primary School (£)': '0.56' } } }
      let(:rate) { { 'M.142': '0.3', 'M.146': '41.91' } }

      it 'returns true' do
        expect(validator.save).to be true
      end

      it 'updates the discounts' do
        validator.save
        expect(rate_card[:data][:Discounts][supplier_id][:'E.2'][:'Disc %']).to eq 0.3
        expect(rate_card[:data][:Discounts][supplier_id][:'H.5'][:'Disc %']).to eq 0.0
      end

      it 'updates the prices' do
        validator.save
        expect(rate_card[:data][:Prices][supplier_id][:'E.2'][:'Restaurant and Catering Facilities']).to eq 0.406
        expect(rate_card[:data][:Prices][supplier_id][:'H.5'][:'Pre-School']).to eq 8.513
        expect(rate_card[:data][:Prices][supplier_id][:'M.1'][:'Primary School']).to eq 0.56
      end

      it 'updates the variances' do
        validator.save
        expect(rate_card[:data][:Variances][supplier_id][:'Profit %']).to eq 0.3
        expect(rate_card[:data][:Variances][supplier_id][:'Cleaning Consumables per Building User (£)']).to eq 41.91
      end
    end

    context 'when the data and rates are not valid' do
      let(:data) { { 'E.2': { 'Direct Award Discount (%)': 'geoff', 'Restaurant and Catering Facilities (£)': 'Crazy' }, 'H.5': { 'Direct Award Discount (%)': '0.0', 'Pre-School (£)': 'Henry VIII' }, 'M.1': { 'Special Schools (£)': '-0.1' }, 'N.1': { 'Primary School (£)': '1.0004' } } }
      let(:rate) { { 'M.141': '0.910000000000000000001', 'M.142': '1.016', 'M.146': '-1.3' } }

      it 'returns false' do
        expect(validator.save).to be false
      end

      it 'has the right error messages' do
        validator.save
        expect(validator.invalid_services).to match(
          'E.2' => { 'Direct Award Discount (%)' => { value: 'geoff', error_type: 'not_a_number' }, 'Restaurant and Catering Facilities (£)' => { value: 'Crazy', error_type: 'not_a_number' } },
          'H.5' => { 'Pre-School (£)' => { value: 'Henry VIII', error_type: 'not_a_number' } },
          'M.1' => { 'Special Schools (£)' => { value: '-0.1', error_type: 'greater_than_or_equal_to' } },
          'N.1' => { 'Primary School (£)' => { value: '1.0004', error_type: 'less_than_or_equal_to' } },
          'M.141' => { value: '0.910000000000000000001', error_type: 'more_than_max_decimals' },
          'M.142' => { value: '1.016', error_type: 'less_than_or_equal_to' },
          'M.146' => { value: '-1.3', error_type: 'greater_than_or_equal_to' }
        )
      end
    end
  end
end
