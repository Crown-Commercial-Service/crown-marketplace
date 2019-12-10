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
end
