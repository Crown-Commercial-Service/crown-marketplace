require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementAuthorisedContactDetail do
  let(:procurement_authorised_contact_detail) { create(:facilities_management_rm3830_procurement_authorised_contact_detail) }

  describe '#telephone_number' do
    context 'when telephone_number is only one space character' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = ' '
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be false
      end
    end

    context 'when telephone_number uses invalid characters: .' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = '0.156465'
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be false
      end
    end

    context 'when telephone_number uses invalid characters: letters' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = 'qmdhfbsbdh'
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be false
      end
    end

    context 'when telephone_number is valid' do
      it 'expected to be valid' do
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be true
      end
    end

    context 'when telephone_number has spaces' do
      it 'expected to be valid' do
        procurement_authorised_contact_detail.telephone_number = '123 4567 8910'
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be true
      end
    end

    context 'when telephone_number is all spaces' do
      it 'expected to be valid' do
        procurement_authorised_contact_detail.telephone_number = '           '
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be false
      end
    end

    context 'when telephone_number is less than 11 character long' do
      it 'expected to not be valid' do
        procurement_authorised_contact_detail.telephone_number = 1234567891
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be false
      end
    end

    context 'when telephone_number is 15 character long' do
      it 'expected to be valid' do
        procurement_authorised_contact_detail.telephone_number = 123456789123456
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be true
      end
    end

    context 'when telephone_number is 16 character long' do
      it 'expected to be invalid' do
        procurement_authorised_contact_detail.telephone_number = 1234567891234567
        expect(procurement_authorised_contact_detail.valid?(:new_authorised_representative)).to be false
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:procurement).class_name('FacilitiesManagement::RM3830::Procurement') }
  end
end
