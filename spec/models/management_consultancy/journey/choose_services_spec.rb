require 'rails_helper'

RSpec.describe ManagementConsultancy::Journey::ChooseServices, type: :model do
  subject(:step) { described_class.new(services: %w[MFC1.2.1]) }

  let(:model_key) { 'activemodel.errors.models.management_consultancy/journey/choose_services' }

  it { is_expected.to be_valid }

  context 'when services does not contain at least 1 code' do
    before do
      step.services = []
    end

    it { is_expected.not_to be_valid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:services]).to include(
        I18n.t("#{model_key}.attributes.services.too_short")
      )
    end
  end

  describe '#lot' do
    it 'is expected to find the correct lot' do
      lot_number = 'MFC1.2'
      lot = ManagementConsultancy::Lot.find_by(number: lot_number)

      expect(step.lot(lot_number)).to eq lot
    end
  end

  describe '#services_for_lot' do
    it 'is expected to find the correct services for the lot' do
      lot_number = 'MFC1.2'
      services = ManagementConsultancy::Service.where(lot_number: lot_number)

      expect(step.services_for_lot(lot_number)).to eq services
    end
  end
end
