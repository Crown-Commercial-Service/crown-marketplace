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
    end
  end
end
