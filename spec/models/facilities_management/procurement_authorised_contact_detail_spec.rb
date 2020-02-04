require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementAuthorisedContactDetail, type: :model do
  let(:procurement_authorised_contact_detail) { create(:facilities_management_procurement_authorised_contact_detail) }

  it { is_expected.to validate_presence_of :telephone_number }

  describe '#telephone_number' do
    context 'when telephone_number is only one space character' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = ' '
        expect(procurement_authorised_contact_detail.valid?(:telephone_number)).to eq false
      end
    end

    context 'when telephone_number uses invalid characters: .' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = '0.156465'
        expect(procurement_authorised_contact_detail.valid?(:telephone_number)).to eq false
      end
    end

    context 'when telephone_number uses invalid characters: space' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = '01234 56789'
        expect(procurement_authorised_contact_detail.valid?(:telephone_number)).to eq false
      end
    end

    context 'when telephone_number is valid' do
      it 'expected to be valid' do
        expect(procurement_authorised_contact_detail.valid?(:telephone_number)).to eq true
      end
    end

    context 'when telephone_number is 11 character long' do
      it 'expected to be valid' do
        procurement_authorised_contact_detail.telephone_number = 12345678912
        expect(procurement_authorised_contact_detail.valid?(:telephone_number)).to eq true
      end
    end

    context 'when telephone_number is 12 character long' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = 123456789122
        expect(procurement_authorised_contact_detail.valid?(:telephone_number)).to eq false
      end
    end

    context 'when telephone_number is 12 character long' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = 123456789123
        expect(procurement_authorised_contact_detail.valid?(:telephone_number)).to eq false
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:procurement).class_name('FacilitiesManagement::Procurement') }
  end
end
