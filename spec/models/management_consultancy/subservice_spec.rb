require 'rails_helper'

RSpec.describe ManagementConsultancy::Subservice, type: :model do
  subject(:subservices) { described_class.all }

  let(:first_subservice) { subservices.first }
  let(:all_codes) { described_class.all_codes }

  it 'loads services from CSV' do
    expect(subservices.count).to eq(103)
  end

  it 'populates attributes of first service' do
    expect(first_subservice.code).to eq('MCF2.1.7.1')
    expect(first_subservice.name).to eq('Outsourcing')
    expect(first_subservice.service).to eq('MCF2.1.7')
  end

  it 'only has unique codes' do
    expect(all_codes.uniq).to contain_exactly(*all_codes)
  end

  it 'all have names' do
    expect(subservices.select { |s| s.name.blank? }).to be_empty
  end

  describe '.all_codes' do
    it 'returns codes for all services' do
      expect(all_codes.count).to eq(subservices.count)
      expect(all_codes.first).to eq(first_subservice.code)
    end
  end
end
