require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementBuildingsHelper do
  describe '.procurement_services' do
    let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: create(:user), service_codes: %w[E.1 E.2 Q.3]) }
    let(:user) { create(:user) }
    let(:result) { helper.procurement_services }

    before { @procurement = procurement }

    it 'returns the services for the procurement' do
      expect(result.first.class.to_s).to eq('FacilitiesManagement::RM6232::Service')
      expect(result.map(&:code)).to match_array(%w[E.1 E.2 Q.3])
    end
  end
end
