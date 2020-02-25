require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::ProcurementsHelper, type: :helper do
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
end
