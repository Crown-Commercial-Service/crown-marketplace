require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SublotServicesValidator do
  let(:validator) { described_class.new(params, latest_rate_card, prices, discounts, variance) }
  let(:supplier_id) { FacilitiesManagement::Admin::SuppliersAdmin.find_by(supplier_name: 'Abernathy and Sons').supplier_id.to_sym }

  describe 'validation methods' do
    let(:params) { {} }
    let(:latest_rate_card) { nil }
    let(:prices) { nil }
    let(:discounts) { nil }
    let(:variance) { nil }

    describe '.numeric?' do
      let(:result) { validator.send(:numeric?, value) }

      context 'when the number is nil' do
        let(:value) { nil }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is empty' do
        let(:value) { '' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is white space' do
        let(:value) { '  ' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is an integer' do
        let(:value) { '1' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is a float' do
        let(:value) { '1.1' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is not numeric' do
        let(:value) { 'Bob' }

        it 'returns false' do
          expect(result).to be false
        end
      end
    end

    describe '.more_than_max_decimals?' do
      let(:result) { validator.send(:more_than_max_decimals?, value) }

      context 'when the number is nil' do
        let(:value) { nil }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when the number is empty' do
        let(:value) { '' }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when the number is white space' do
        let(:value) { '  ' }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there are 20 significant ficures after the decimal point' do
        let(:value) { '1.12345678901234567890' }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when there are 21 significant ficures after the decimal point' do
        let(:value) { '1.123456789012345678901' }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end

    describe '.value_in_range?' do
      let(:result) { validator.send(:value_in_range?, value) }

      context 'when the number is nil' do
        let(:value) { nil }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is empty' do
        let(:value) { '' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is white space' do
        let(:value) { '  ' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when there are more than max decimals' do
        let(:value) { '0.123456789012345678901' }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when the number is more than 1' do
        let(:value) { '1.00000001' }

        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when the number is 1' do
        let(:value) { '1' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the number is less than 1' do
        let(:value) { '0.9999999' }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end
  end

  describe '.save' do
    let(:params) { ActionController::Parameters.new('data': data, 'rate': rate) }
    let(:latest_rate_card) { CCS::FM::RateCard.latest }
    let(:prices) { latest_rate_card[:data][:Prices][supplier_id].deep_stringify_keys! }
    let(:discounts) { latest_rate_card[:data][:Discounts][supplier_id].deep_stringify_keys! }
    let(:variance) { latest_rate_card[:data][:Variances][supplier_id] }
    let(:rate_card) { CCS::FM::RateCard.latest }

    context 'when the data and rates are valid' do
      let(:data) { { 'E.2': { 'Direct Award Discount (%)': '0.3', 'Restaurant and Catering Facilities (£)': '0.406' }, 'H.5': { 'Direct Award Discount (%)': '0.0', 'Pre-School (£)': '8.513' } } }
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
      end

      it 'updates the variances' do
        validator.save
        expect(rate_card[:data][:Variances][supplier_id][:'Profit %']).to eq 0.3
        expect(rate_card[:data][:Variances][supplier_id][:'Cleaning Consumables per Building User (£)']).to eq 41.91
      end
    end

    context 'when the data and rates are not valid' do
      let(:data) { { 'E.2': { 'Direct Award Discount (%)': 'geoff', 'Restaurant and Catering Facilities (£)': 'Crazy' }, 'H.5': { 'Direct Award Discount (%)': '0.0', 'Pre-School (£)': 'Henry VIII' } } }
      let(:rate) { { 'M.142': '1.016', 'M.146': '41.91' } }

      it 'returns false' do
        expect(validator.save).to be false
      end

      it 'has the right error messages' do
        validator.save
        expect(validator.invalid_services).to match(
          'E.2' => { 'Direct Award Discount (%)' => 'geoff', 'Restaurant and Catering Facilities (£)' => 'Crazy' },
          'H.5' => { 'Pre-School (£)' => 'Henry VIII' },
          'M.142' => '1.016'
        )
      end
    end
  end
end
