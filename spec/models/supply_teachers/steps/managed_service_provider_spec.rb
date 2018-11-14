require 'rails_helper'

RSpec.describe SupplyTeachers::Steps::ManagedServiceProvider, type: :model do
  subject(:step) { described_class.new(managed_service_provider: 'master_vendor') }

  let(:model_key) { 'activemodel.errors.models.supply_teachers/steps/managed_service_provider' }

  it { is_expected.to be_valid }

  context 'when managed_service_provider is not valid' do
    before do
      step.managed_service_provider = 'unacceptable-value'
    end

    it { is_expected.not_to be_valid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:managed_service_provider]).to include(
        I18n.t("#{model_key}.attributes.managed_service_provider.inclusion")
      )
    end
  end
end
