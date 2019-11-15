require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user, confirmed_at: confirmed_at) }

  describe '#confirmed?' do
    context 'when confirmed_at blank' do
      let(:confirmed_at) { nil }

      it 'returns false' do
        expect(user.confirmed?).to eq false
      end
    end

    context 'when confirmed_at is a date' do
      let(:confirmed_at) { Time.zone.now }

      it 'returns true' do
        expect(user.confirmed?).to eq true
      end
    end
  end

  describe '#fm_buyer_details_incomplete?' do
    let(:confirmed_at) { Time.zone.now }

    context 'when user is buyer without buyer details' do
      it 'will return true' do
        user.roles = %i[buyer fm_access]
        expect(user.fm_buyer_details_incomplete?).to eq true
      end
    end

    context 'when user isn\'t a buyer' do
      it 'will return false' do
        user.roles = %i[fm_access]
        expect(user.fm_buyer_details_incomplete?).to eq false
      end
    end

    context 'when user is a buyer and has empty details' do
      it 'will return true' do
        user.roles = %i[buyer fm_access]
        user.buyer_detail = nil
        expect(user.fm_buyer_details_incomplete?).to eq true
      end
    end

    context 'when user is a buyer and has incomplete details' do
      it 'will return true' do
        user.roles = %i[buyer fm_access]
        user.buyer_detail = FacilitiesManagement::BuyerDetail.new
        user.buyer_detail.full_name = 'Test name'
        expect(user.fm_buyer_details_incomplete?).to eq true
      end
    end

    context 'when user is a buyer and has complete details' do
      it 'will return true' do
        user.roles = %i[buyer fm_access]
        user.buyer_detail = FacilitiesManagement::BuyerDetail.new
        user.buyer_detail.full_name = 'Test name'
        user.buyer_detail.job_title = 'Job title'
        user.buyer_detail.telephone_number = '3434'
        user.buyer_detail.organisation_name = 'org name'
        user.buyer_detail.organisation_address_postcode = 'postcode'
        user.buyer_detail.central_government = true

        expect(user.fm_buyer_details_incomplete?).to eq false
      end
    end
  end
end
