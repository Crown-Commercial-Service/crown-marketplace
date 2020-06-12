require 'rails_helper'

RSpec.describe FacilitiesManagement::BuyerDetail, type: :model do
  subject(:buyer_detail) { create(:buyer_detail, user: create(:user)) }

  describe '#validations' do
    # before do
    #   buyer_detail
    # end

    context 'when everything is present' do
      it 'is valid' do
        expect(buyer_detail.valid?).to eq true
      end
    end

    context 'when full name not present' do
      it 'is invalid' do
        expect(buyer_detail.update(full_name: nil)).to eq false
      end
    end

    context 'when job title not present' do
      it 'is invalid' do
        expect(buyer_detail.update(job_title: nil)).to eq false
      end
    end

    context 'when everything is present verify alias methods' do
      it 'is valid email' do
        expect(buyer_detail.user.email).to eq buyer_detail.email
      end
    end

    context 'when telephone number not present' do
      it 'is invalid' do
        expect(buyer_detail.update(telephone_number: nil)).to eq false
      end
    end

    context 'when organisation name not present' do
      it 'is invalid' do
        expect(buyer_detail.update(organisation_name: nil)).to eq false
      end
    end

    context 'when organisation postcode not present' do
      it 'is invalid' do
        expect(buyer_detail.update(organisation_address_postcode: nil)).to eq false
      end

      it 'will throw an error' do
        buyer_detail.organisation_address_postcode = 'SAN TA1'
        buyer_detail.save
        # binding.pry
        # expect(buyer_detail.attributes[:organisation_address_postcode].errors[:invalid].first).to eq 'Enter a valid postcode, for example SW1A 1AA'
        expect(buyer_detail.errors.messages).to eq(organisation_address_postcode: ['Enter a valid postcode, for example SW1A 1AA'])
      end
    end

    context 'when organisation line 1 is not present on update_address context' do
      it 'is invalid' do
        buyer_detail.organisation_address_line_1 = nil
        expect(buyer_detail.valid?(:update_address)).to eq false
      end
    end

    context 'when organisation town is not present on update_address context' do
      it 'is invalid' do
        buyer_detail.organisation_address_town = nil
        expect(buyer_detail.valid?(:update_address)).to eq false
      end
    end

    context 'when organisation postcode is not present on update_address context' do
      it 'is invalid' do
        buyer_detail.organisation_address_postcode = nil
        expect(buyer_detail.valid?(:update_address)).to eq false
      end
    end
  end

  describe '#full_organisation_address' do
    it 'returns the existing address without any extra commas' do
      expect(buyer_detail.full_organisation_address).to eq buyer_detail.organisation_address_line_1 + ', ' + buyer_detail.organisation_address_line_2 + ', ' + buyer_detail.organisation_address_town + ', ' + buyer_detail.organisation_address_county + ' ' + buyer_detail.organisation_address_postcode
    end
    it 'returns the existing address without address line 2 or county' do
      buyer_detail.organisation_address_line_2 = nil
      buyer_detail.organisation_address_county = nil
      expect(buyer_detail.full_organisation_address).to eq buyer_detail.organisation_address_line_1 + ', ' + buyer_detail.organisation_address_town + ' ' + buyer_detail.organisation_address_postcode
    end
  end
end
