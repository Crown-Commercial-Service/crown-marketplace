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

  describe '.further_competition_saved_date' do
    include ApplicationHelper

    let(:procurement) { create(:facilities_management_procurement, contract_datetime: contract_datetime) }

    context 'when the contract_datetime is 01/02/2019 -  2:53pm' do
      let(:contract_datetime) { '01/02/2019 -  2:53pm' }

      it 'returns 1 February 2019, 2:53pm' do
        expect(helper.further_competition_saved_date(procurement)).to eq ' 1 February 2019,  2:53pm'
      end
    end

    context 'when the contract_datetime is 15/01/2020 -  11:05am' do
      let(:contract_datetime) { '15/01/2020 -  11:05am' }

      it 'returns 15 January 2020, 11:05am' do
        expect(helper.further_competition_saved_date(procurement)).to eq '15 January 2020, 11:05am'
      end
    end

    context 'when the contract_datetime is 06/09/2021 - 2:26am' do
      let(:contract_datetime) { '06/09/2021 - 2:26am' }

      it 'returns 6 September 2021, 3:26am	' do
        expect(helper.further_competition_saved_date(procurement)).to eq ' 6 September 2021,  3:26am'
      end
    end

    context 'when the contract_datetime is 17/12/2020 -10:11pm' do
      let(:contract_datetime) { ' 17/12/2020 -10:11pm' }

      it 'returns 17 December 2020, 10:11pm' do
        expect(helper.further_competition_saved_date(procurement)).to eq '17 December 2020, 10:11pm'
      end
    end
  end
end
