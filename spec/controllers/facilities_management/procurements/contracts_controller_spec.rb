require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurements::ContractsController, type: :controller do
  let(:contract) { create(:facilities_management_procurement_supplier) }

  describe '.authorize_user' do
    let(:procurement) { create(:facilities_management_procurement, user: user) }

    let(:user) { FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }
    let(:wrong_user) { FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access]) }

    context 'when the user is not the intended buyer' do
      it 'will not be able to manage the procurement' do
        sign_in wrong_user
        ability = Ability.new(wrong_user)
        assert ability.cannot?(:manage, procurement)
      end
    end

    context 'when the user is the intended buyer' do
      it 'will be able to manage the procurement' do
        sign_in user
        ability = Ability.new(user)
        assert ability.can?(:manage, procurement)
      end
    end
  end
end
