require 'rails_helper'

module ManagementConsultancy
  RSpec.describe Service, type: :model do
    subject(:services) { described_class.all }

    let(:first_service) { services.first }

    it 'loads services from CSV' do
      expect(services.count).to eq(85)
    end

    it 'populates attributes of first service' do
      expect(first_service.code).to eq('1.1')
      expect(first_service.name).to eq('Business case development')
      expect(first_service.lot_number).to eq('1')
    end
  end
end
