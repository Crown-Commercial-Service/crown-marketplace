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
    context 'with a procurement in direct_award' do
      it 'verify contract rate card worksheet headers' do
        expect(wb.sheet('Contract Rate Card').row(1)).to match_array(['Bogan-Koch', nil, nil, nil])
        expect(wb.sheet('Contract Rate Card').row(2)).to match_array(['Table 1. Service rates', nil, nil, nil])
        expect(wb.sheet('Contract Rate Card').row(3)).to match_array(['Service Reference', 'Service Name', 'Unit of Measure', 'General office - Customer Facing'])
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify contract rate card worksheet calculations' do
        expect(wb.sheet('Contract Rate Card').row(4)).to match_array(['C.1', 'Mechanical and Electrical Engineering Maintenance - Standard A', 'price per Square Metre (GIA)', 1.71])
        expect(wb.sheet('Contract Rate Card').row(9)).to match_array(['Cleaning Consumables', 'price per building occupant per annum', 47.52, nil])
        expect(wb.sheet('Contract Rate Card').row(10)).to match_array(['Management Overhead', 'percentage of deliverables value', 0.0736, nil])
        expect(wb.sheet('Contract Rate Card').row(11)).to match_array(['Corporate Overhead', 'percentage of deliverables value', 0.0613, nil])
        expect(wb.sheet('Contract Rate Card').row(12)).to match_array(['Profit', 'percentage of deliverables value', 0.092, nil])
        expect(wb.sheet('Contract Rate Card').row(13)).to match_array(['London Location Variance Rate', 'variance to standard service rate', 0.45, nil])
        expect(wb.sheet('Contract Rate Card').row(14)).to match_array(['TUPE Risk Premium', 'percentage of deliverables value', 0.0771, nil])
        expect(wb.sheet('Contract Rate Card').row(15)).to match_array(['Mobilisation Cost', 'percentage of deliverables value', 0.038, nil])
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'contract price matrix worksheet' do
    context 'with a procurement in direct_award' do
      it 'verify contract price matrix worksheet headers' do
        expect(wb.sheet('Contract Price Matrix').row(2)).to match_array(['Table 1. Baseline service costs for year 1', nil, nil, nil, nil])
        expect(wb.sheet('Contract Price Matrix').row(3)).to match_array(['Service Reference', 'Service Name', 'Total', 'Building 1', 'Building 2'])
        expect(wb.sheet('Contract Price Matrix').row(4)).to match_array([nil, nil, nil, 'asa', 'asa'])
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'verify price matrix card worksheet calculations' do
        expect(wb.sheet('Contract Price Matrix').row(5)).to match_array(['C.1', 'Mechanical and Electrical Engineering Maintenance - Standard A', 3426.84, 1713.42, 1713.42])
        expect(wb.sheet('Contract Price Matrix').row(6)).to match_array(['Planned Deliverables sub total', nil, 3426.84, 1713.42, 1713.42])
        expect(wb.sheet('Contract Price Matrix').row(8)).to match_array(['CAFM', nil, 0.0, 0.0, 0.0])
        expect(wb.sheet('Contract Price Matrix').row(9)).to match_array(['Helpdesk', nil, 0.0, 0.0, 0.0])
        expect(wb.sheet('Contract Price Matrix').row(15)).to match_array(['Mobilisation', nil, 130.21992, 65.10996, 65.10996])
        expect(wb.sheet('Contract Price Matrix').row(16)).to match_array(['TUPE Risk Premium', nil, 264.209364, 132.104682, 132.104682])
        expect(wb.sheet('Contract Price Matrix').row(19)).to match_array(['Management Overhead', nil, 281.24541930239997, 140.62270965119998, 140.62270965119998])
        expect(wb.sheet('Contract Price Matrix').row(20)).to match_array(['Corporate Overhead', nil, 234.2438071092, 117.1219035546, 117.1219035546])
        expect(wb.sheet('Contract Price Matrix').row(22)).to match_array(['Profit', nil, 351.556774128, 175.778387064, 175.778387064])
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
