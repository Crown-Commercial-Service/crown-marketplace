require 'rails_helper'

RSpec.describe LegalServices::Service, type: :model do
  subject(:services) { described_class.all }

  let(:available_to_central_government) { described_class.where(central_government: 'yes') }
  let(:first_service) { services.first }
  let(:all_codes) { described_class.all_codes }

  it 'loads services from CSV' do
    expect(services.count).to eq(121)
  end

  it 'populates attributes of first service' do
    expect(first_service.code).to eq('WPSLS.1.1')
    expect(first_service.name).to eq('Property and construction')
    expect(first_service.lot_number).to eq('1')
  end

  it 'only has unique codes' do
    expect(all_codes.uniq).to contain_exactly(*all_codes)
  end

  it 'all have names' do
    expect(services.select { |s| s.name.blank? }).to be_empty
  end

  it 'all to say if they are available to central government' do
    expect(services.select { |s| s.central_government.blank? }).to be_empty
  end

  it 'to only have some services available to central government buyers' do
    expect(available_to_central_government.count).to eq(2)
  end

  describe '.all_codes' do
    it 'returns codes for all services' do
      expect(all_codes.count).to eq(services.count)
      expect(all_codes.first).to eq(first_service.code)
    end
  end

  describe '.services_for_lot' do
    context 'when lot is 2' do
      it 'returns the services for lot 2a' do
        lot_2_services = described_class.where(lot_number: '2a')

        expect(described_class.services_for_lot('2')).to eq(lot_2_services)
      end
    end

    context 'when selecting from lots 1,3 or 4' do
      ['1', '3', '4'].each do |lot_number|
        it 'returns the correct services for that lot' do
          selected_lot_services = described_class.where(lot_number: lot_number)
          expect(described_class.services_for_lot(lot_number)).to eq(selected_lot_services)
        end
      end
    end
  end
end
