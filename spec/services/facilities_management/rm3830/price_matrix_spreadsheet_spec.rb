require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::PriceMatrixSpreadsheet do
  include ActionView::Helpers::NumberHelper

  subject(:wb) do
    spreadsheet = described_class.new contract.id
    spreadsheet.build
    path = '/tmp/Attachment_3_Price_Matrix_(DA).xlsx'
    File.write(path, spreadsheet.to_xlsx, binmode: true)
    Roo::Excelx.new(path)
  end

  let(:user) { create(:user, :with_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }
  let(:procurement) { create(:facilities_management_rm3830_procurement_with_contact_details_with_buildings, user: user) }
  let(:supplier_name) { 'Bogan-Koch' }
  let(:supplier_details) { create(:facilities_management_rm3830_supplier_detail_with_lots) }
  let(:supplier) { FacilitiesManagement::RM3830::SupplierDetail.find_by(supplier_name: supplier_name) }
  let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

  before { supplier.update(lot_data: supplier_details.lot_data) }

  describe 'contract rate card worksheet' do
    subject(:rates) { wb.sheet('Contract Rate Card') }

    before do
      procurement.active_procurement_buildings.each { |apb| apb.update(service_codes: ['C.1']) }
    end

    context 'with a procurement in direct_award' do
      it 'verify contract rate card worksheet headers' do
        expect(rates.row(1)).to contain_exactly(supplier_name, nil, nil, nil)
        expect(rates.row(2)).to contain_exactly('Table 1. Service rates', nil, nil, nil)
        expect(rates.row(3)).to contain_exactly('Service Reference', 'Service Name', 'Unit of Measure', 'General office - Customer Facing')
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify contract rate card worksheet calculations' do
        expect(rates.row(4)).to contain_exactly('C.1', 'Mechanical and Electrical Engineering Maintenance - Standard A', 'price per Square Metre (GIA)', 2.415569972196478)
        expect(rates.row(9)).to contain_exactly('Cleaning Consumables', 'price per building occupant per annum', 20.129749768303984, nil)
        expect(rates.row(10)).to contain_exactly('Management Overhead', 'percentage of deliverables value', 0.15, nil)
        expect(rates.row(11)).to contain_exactly('Corporate Overhead', 'percentage of deliverables value', 0.052, nil)
        expect(rates.row(12)).to contain_exactly('Profit', 'percentage of deliverables value', 0.047, nil)
        expect(rates.row(13)).to contain_exactly('London Location Variance Rate', 'variance to standard service rate', 0.1, nil)
        expect(rates.row(14)).to contain_exactly('TUPE Risk Premium', 'percentage of deliverables value', 0.05, nil)
        expect(rates.row(15)).to contain_exactly('Mobilisation Cost', 'percentage of deliverables value', 0.027, nil)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'contract price matrix worksheet' do
    subject(:prices) { wb.sheet('Contract Price Matrix') }

    context 'with a procurement in direct_award' do
      it 'verify contract price matrix worksheet headers' do
        expect(prices.row(2)).to contain_exactly('Table 1. Baseline service costs for year 1', nil, nil, nil, nil)
        expect(prices.row(3)).to contain_exactly('Service Reference', 'Service Name', 'Total', 'Building 1', 'Building 2')
        expect(prices.row(4)).to contain_exactly(nil, nil, nil, 'asa', 'asa')
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify price matrix card worksheet calculations' do
        expect(prices.row(5)).to contain_exactly('C.1', 'Mechanical and Electrical Engineering Maintenance - Standard A', 2390.1460982391104, 2390.1460982391104, 4780.292196478221)
        expect(prices.row(6)).to contain_exactly('Planned Deliverables sub total', nil, 2390.1460982391104, 2390.1460982391104, 4780.292196478221)
        expect(prices.row(8)).to contain_exactly('CAFM', nil, 0.0, 0.0, 0.0)
        expect(prices.row(9)).to contain_exactly('Helpdesk', nil, 0.0, 0.0, 0.0)
      end
      # rubocop:enable RSpec/MultipleExpectations

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify boilerplate text' do
        expect(prices.row(30)[0]).to eq('NOTES')
        expect(prices.row(31)[0]).to match(/^For service/)
        expect(prices.row(32)[0]).to match(/^For service/)
        expect(prices.row(33)[0]).to match(/^For service/)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
