require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementsHelper, type: :helper do
  describe '#building_services_status?' do
    context 'when supplied truthy' do
      it 'will return \'Complete\'' do
        expect(helper.building_services_status?(true)).to eq 'Complete'
      end
    end

    context 'when supplied falsy' do
      it 'will return \'Incomplete\'' do
        expect(helper.building_services_status?(false)).to eq 'Incomplete'
      end
    end
  end

  describe '#to_lower_case' do
    context 'when the string starts with an acronym' do
      it 'will not change the first letter to lower case' do
        expect(to_lower_case('CCTV / alarm monitoring')).to eq 'CCTV / alarm monitoring'
        expect(to_lower_case('CAFM system')).to eq 'CAFM system'
        expect(to_lower_case('IT equipment cleaning')).to eq 'IT equipment cleaning'
      end
    end

    context 'when the string does not start with an acronym' do
      it 'will change the first letter to lower case' do
        expect(to_lower_case('Compliance plans, specialist surveys and audits')).to eq 'compliance plans, specialist surveys and audits'
        expect(to_lower_case('standby power system maintenance')).to eq 'standby power system maintenance'
        expect(to_lower_case('gEneral waste')).to eq 'gEneral waste'
      end
    end
  end

  describe 'sort pension funds' do
    context 'when sort works when created_at is nil' do
      it 'will sort with the nil value for created_at' do
        new_procurement = create(:facilities_management_procurement)
        pension_fund1 = create(:facilities_management_procurement_pension_fund, created_at: 1.day.ago, procurement: new_procurement)
        create(:facilities_management_procurement_pension_fund, created_at: 4.days.ago, procurement: new_procurement)
        pension_fund3 = create(:facilities_management_procurement_pension_fund, created_at: nil, procurement: new_procurement)
        create(:facilities_management_procurement_pension_fund, created_at: 2.days.ago, procurement: new_procurement)

        @procurement = pension_fund1.procurement
        sorted = sort_by_pension_fund_created_at
        expect(sorted.size).to eq 4
        expect(sorted[3].id).to eq pension_fund3.id # nil value is at the end
      end
    end
  end
end
