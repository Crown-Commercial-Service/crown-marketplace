require 'rails_helper'

RSpec.describe FacilitiesManagement::DirectAwardSpreadsheet do
  include ActionView::Helpers::NumberHelper

  subject(:wb) do
    spreadsheet = described_class.new contract.id
    path = '/tmp/Attachment_3_Price_Matrix_(DA).xlsx'
    IO.write(path, spreadsheet.to_xlsx)
    Roo::Excelx.new(path)
  end

  let(:user) { create(:user, :with_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }
  let(:procurement) { create(:facilities_management_procurement_with_contact_details_with_buildings, user: user) }
  let(:supplier) { create(:ccs_fm_supplier_with_lots, :with_supplier_name, name: 'Bogan-Koch') }
  let(:contract) { create(:facilities_management_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

  describe 'contract rate card worksheet' do
    subject(:rates) { wb.sheet('Contract Rate Card') }

    context 'with a procurement in direct_award' do
      it 'verify contract rate card worksheet headers' do
        expect(rates.row(1)).to match_array(['Bogan-Koch', nil, nil, nil])
        expect(rates.row(2)).to match_array(['Table 1. Service rates', nil, nil, nil])
        expect(rates.row(3)).to match_array(['Service Reference', 'Service Name', 'Unit of Measure', 'General office - Customer Facing'])
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify contract rate card worksheet calculations' do
        expect(rates.row(4)).to match_array(['C.1', 'Mechanical and Electrical Engineering Maintenance - Standard A', 'price per Square Metre (GIA)', 1.71])
        expect(rates.row(9)).to match_array(['Cleaning Consumables', 'price per building occupant per annum', 47.52, nil])
        expect(rates.row(10)).to match_array(['Management Overhead', 'percentage of deliverables value', 0.0736, nil])
        expect(rates.row(11)).to match_array(['Corporate Overhead', 'percentage of deliverables value', 0.0613, nil])
        expect(rates.row(12)).to match_array(['Profit', 'percentage of deliverables value', 0.092, nil])
        expect(rates.row(13)).to match_array(['London Location Variance Rate', 'variance to standard service rate', 0.45, nil])
        expect(rates.row(14)).to match_array(['TUPE Risk Premium', 'percentage of deliverables value', 0.0771, nil])
        expect(rates.row(15)).to match_array(['Mobilisation Cost', 'percentage of deliverables value', 0.038, nil])
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'contract price matrix worksheet' do
    subject(:prices) { wb.sheet('Contract Price Matrix') }

    context 'with a procurement in direct_award' do
      it 'verify contract price matrix worksheet headers' do
        expect(prices.row(2)).to match_array(['Table 1. Baseline service costs for year 1', nil, nil, nil, nil])
        expect(prices.row(3)).to match_array(['Service Reference', 'Service Name', 'Total', 'Building 1', 'Building 2'])
        expect(prices.row(4)).to match_array([nil, nil, nil, 'asa', 'asa'])
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify price matrix card worksheet calculations' do
        expect(prices.row(5)).to match_array(['C.1', 'Mechanical and Electrical Engineering Maintenance - Standard A', 3426.84, 1713.42, 1713.42])
        expect(prices.row(6)).to match_array(['Planned Deliverables sub total', nil, 3426.84, 1713.42, 1713.42])
        expect(prices.row(8)).to match_array(['CAFM', nil, 0.0, 0.0, 0.0])
        expect(prices.row(9)).to match_array(['Helpdesk', nil, 0.0, 0.0, 0.0])
      end
      # rubocop:enable RSpec/MultipleExpectations

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify boilerplate text' do
        expect(prices.row(32)[0]).to eq('NOTES')
        expect(prices.row(33)[0]).to match(/^For service/)
        expect(prices.row(34)[0]).to match(/^For service/)
        expect(prices.row(35)[0]).to match(/^For service/)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
