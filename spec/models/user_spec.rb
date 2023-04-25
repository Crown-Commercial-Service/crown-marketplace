require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user, :without_detail, confirmed_at:) }

  describe '#confirmed?' do
    context 'when confirmed_at blank' do
      let(:confirmed_at) { nil }

      it 'returns false' do
        expect(user.confirmed?).to be false
      end
    end

    context 'when confirmed_at is a date' do
      let(:confirmed_at) { Time.zone.now }

      it 'returns true' do
        expect(user.confirmed?).to be true
      end
    end
  end

  describe '#fm_buyer_details_incomplete?' do
    let(:confirmed_at) { Time.zone.now }

    context 'when user is buyer without buyer details' do
      it 'will return true' do
        user.roles = %i[buyer fm_access]
        expect(user.fm_buyer_details_incomplete?).to be true
      end
    end

    context 'when user isn\'t a buyer' do
      it 'will return false' do
        user.roles = %i[fm_access]
        expect(user.fm_buyer_details_incomplete?).to be false
      end
    end

    context 'when user is a buyer and has empty details' do
      it 'will return true' do
        user.roles = %i[buyer fm_access]
        user.buyer_detail = nil
        expect(user.fm_buyer_details_incomplete?).to be true
      end
    end

    context 'when user is a buyer is missing most of the details' do
      it 'will return true' do
        user.roles = %i[buyer fm_access]
        user.buyer_detail = FacilitiesManagement::BuyerDetail.new
        user.buyer_detail.full_name = 'Test name'
        expect(user.fm_buyer_details_incomplete?).to be true
      end
    end

    context 'when user is a buyer and has incomplete details' do
      before do
        user.roles = %i[buyer fm_access]
        user.buyer_detail = FacilitiesManagement::BuyerDetail.new
        user.buyer_detail.full_name = 'Test name'
        user.buyer_detail.job_title = 'Job title'
        user.buyer_detail.telephone_number = '3434'
        user.buyer_detail.organisation_name = 'org name'
        user.buyer_detail.organisation_address_postcode = 'SW1W 9SZ'
        user.buyer_detail.central_government = false
        user.buyer_detail.contact_opt_in = false
      end

      it 'will return true' do
        expect(user.fm_buyer_details_incomplete?).to be true
      end
    end

    context 'when user is a buyer and has complete details' do
      before do
        user.roles = %i[buyer fm_access]
        user.buyer_detail = FacilitiesManagement::BuyerDetail.new
        user.buyer_detail.full_name = 'Test name'
        user.buyer_detail.job_title = 'Job title'
        user.buyer_detail.telephone_number = '343434343434'
        user.buyer_detail.organisation_name = 'org name'
        user.buyer_detail.organisation_address_line_1 = 'Address line 1'
        user.buyer_detail.organisation_address_town = 'Address town'
        user.buyer_detail.organisation_address_postcode = 'SW1W 9SZ'
        user.buyer_detail.central_government = false
        user.buyer_detail.contact_opt_in = false
      end

      it 'will return false' do
        expect(user.fm_buyer_details_incomplete?).to be false
      end
    end
  end
end
