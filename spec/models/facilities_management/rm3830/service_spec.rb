require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Service do
  subject(:services) { described_class.all }

  let(:first_service) { services.first }
  let(:all_codes) { described_class.all_codes }

  it 'loads services from CSV' do
    expect(services.count).to eq(135)
  end

  it 'all have names' do
    expect(services.select { |s| s.name.blank? }).to be_empty
  end

  it 'all have boolean mandatory attribute' do
    expect(services.reject { |s| [TrueClass, FalseClass].include?(s.mandatory.class) }).to be_empty
  end

  it 'all have a work_package' do
    expect(services.reject { |s| s.work_package.present? }).to be_empty
  end

  it 'populates attributes of first service' do
    expect(first_service.code).to eq('A.7')
    expect(first_service.name).to eq('Accessibility services')
    expect(first_service.work_package_code).to eq('A')
  end

  it 'populates mandatory attribute of first service' do
    expect(first_service).to be_mandatory
  end

  it 'looks up work package based on its code' do
    work_package = first_service.work_package
    expect(work_package.code).to eq('A')
    expect(work_package.name).to eq('Contract management')
  end

  it 'only has unique codes' do
    expect(all_codes.uniq).to match_array(all_codes)
  end

  it 'DA contains an example service' do
    expect((described_class.direct_award_services('123').include? 'C.1')).to be true
  end

  it 'DA contains an example service using a frozen rate' do
    user = create(:user)
    procurement = create(:facilities_management_rm3830_procurement, user:)

    frozen_rate = FacilitiesManagement::RM3830::FrozenRate.new(facilities_management_rm3830_procurement_id: procurement.id, code: 'C.1', framework: 1.2, benchmark: 2.2, standard: 'Y', direct_award: true)
    frozen_rate.save!
    expect((described_class.direct_award_services(procurement.id).include? 'C.1')).to be true
  end

  describe '#mandatory?' do
    let(:service) { described_class.new(mandatory:) }

    context 'when mandatory is "true"' do
      let(:mandatory) { 'true' }

      it 'returns truth-y' do
        expect(service).to be_mandatory
      end
    end

    context 'when mandatory is "false"' do
      let(:mandatory) { 'false' }

      it 'returns false-y' do
        expect(service).not_to be_mandatory
      end
    end
  end

  describe '.all_codes' do
    it 'returns codes for all services' do
      expect(all_codes.count).to eq(services.count)
      expect(all_codes.first).to eq(first_service.code)
    end
  end
end
