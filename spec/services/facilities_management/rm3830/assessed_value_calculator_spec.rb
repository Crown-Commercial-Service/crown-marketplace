require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::AssessedValueCalculator do
  let(:user) { create(:user, :with_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }
  let(:procurement_lot1a) { create(:facilities_management_rm3830_procurement_with_contact_details_with_buildings, user:) }
  let(:procurement_lot1c) { create(:facilities_management_rm3830_procurement_with_contact_details_with_buildings, user: user, lot_number: '1c', lot_number_selected_by_customer: true) }

  describe '.sorted_list' do
    context 'with verify sorted list' do
      it 'has the correct value for lot1a' do
        supplier_assessed_value_list = described_class.new(procurement_lot1a.id).sorted_list(true)

        size = supplier_assessed_value_list.size
        expect(size).to be > 2
        (1..(size - 1)).each do |i|
          expect(supplier_assessed_value_list[i - 1][:da_value]).to be <= supplier_assessed_value_list[i][:da_value]
        end
      end

      it 'has the correct value for lot1c' do
        supplier_assessed_value_list = described_class.new(procurement_lot1c.id).sorted_list(true)

        size = supplier_assessed_value_list.size
        expect(size).to be > 2
        (1..(size - 1)).each do |i|
          expect(supplier_assessed_value_list[i - 1][:da_value]).to eq 0
        end
      end
    end
  end
end
