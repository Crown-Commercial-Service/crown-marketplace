require 'rails_helper'

RSpec.describe FacilitiesManagement::BuyerDetail do
  subject(:buyer_detail) { create(:buyer_detail, user: create(:user)) }

  describe '#validations' do
    context 'when everything is present' do
      it 'is valid' do
        expect(buyer_detail.valid?).to be true
      end
    end

    context 'when considering full name' do
      before { buyer_detail.full_name = full_name }

      context 'when full name not present' do
        let(:full_name) { nil }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when full name is more than max characters' do
        let(:full_name) { 'a' * 256 }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end
    end

    context 'when considering job title' do
      before { buyer_detail.job_title = job_title }

      context 'when job title not present' do
        let(:job_title) { nil }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when job title is more than max characters' do
        let(:job_title) { 'a' * 256 }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end
    end

    context 'when everything is present verify alias methods' do
      it 'has the same email for user and buyer detail' do
        expect(buyer_detail.user.email).to eq buyer_detail.email
      end
    end

    context 'when telephone number not present' do
      it 'is invalid' do
        expect(buyer_detail.update(telephone_number: nil)).to be false
      end
    end

    context 'when considering telephone number' do
      before { buyer_detail.telephone_number = telephone_number }

      context 'when telephone number not present' do
        let(:telephone_number) { nil }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when telephone number is too long' do
        let(:telephone_number) { '0161016101610161' }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when telephone number is too short' do
        let(:telephone_number) { '0161' }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when telephone number is just right' do
        let(:telephone_number) { '016101610161' }

        it 'is valid' do
          expect(buyer_detail.valid?(:update)).to be true
        end
      end
    end

    context 'when considering organisation name' do
      before { buyer_detail.organisation_name = organisation_name }

      context 'when organisation name not present' do
        let(:organisation_name) { nil }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when organisation name is more than max characters' do
        let(:organisation_name) { 'a' * 256 }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end
    end

    context 'when considering organisation postcode' do
      before { buyer_detail.organisation_address_postcode = organisation_address_postcode }

      context 'when organisation postcode not present' do
        let(:organisation_address_postcode) { nil }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end

        it 'has the correct error message' do
          buyer_detail.valid?(:update)

          expect(buyer_detail.errors[:organisation_address_postcode].first).to eq 'Enter a valid postcode, for example SW1A 1AA'
        end
      end

      context 'when organisation postcode is not a valid postcode' do
        let(:organisation_address_postcode) { 'SA3 1TA NW14' }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end

        it 'has the correct error message' do
          buyer_detail.valid?(:update)

          expect(buyer_detail.errors[:organisation_address_postcode].first).to eq 'Enter a valid postcode, for example SW1A 1AA'
        end
      end
    end

    context 'when considering organisation line 1' do
      before { buyer_detail.organisation_address_line_1 = organisation_address_line_1 }

      context 'when organisation line 1 not present' do
        let(:organisation_address_line_1) { nil }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when organisation line 1 is more than max characters' do
        let(:organisation_address_line_1) { 'a' * 256 }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end
    end

    context 'when considering organisation line 2' do
      before { buyer_detail.organisation_address_line_2 = organisation_address_line_2 }

      context 'when organisation line 2 not present' do
        let(:organisation_address_line_2) { nil }

        it 'is valid' do
          expect(buyer_detail.valid?(:update)).to be true
        end
      end

      context 'when organisation line 2 is more than max characters' do
        let(:organisation_address_line_2) { 'a' * 256 }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end
    end

    context 'when considering organisation town' do
      before { buyer_detail.organisation_address_town = organisation_address_town }

      context 'when organisation town not present' do
        let(:organisation_address_town) { nil }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end

      context 'when organisation town is more than max characters' do
        let(:organisation_address_town) { 'a' * 256 }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end
    end

    context 'when considering organisation county' do
      before { buyer_detail.organisation_address_county = organisation_address_county }

      context 'when organisation county not present' do
        let(:organisation_address_county) { nil }

        it 'is valid' do
          expect(buyer_detail.valid?(:update)).to be true
        end
      end

      context 'when organisation county is more than max characters' do
        let(:organisation_address_county) { 'a' * 256 }

        it 'is invalid' do
          expect(buyer_detail.valid?(:update)).to be false
        end
      end
    end

    context 'when considering sector' do
      before { buyer_detail.sector = sector }

      context 'and it is blank' do
        let(:sector) { '' }

        it 'is invalid and has the correct error message' do
          expect(buyer_detail).not_to be_valid(:update)
          expect(buyer_detail.errors[:sector].first).to eq 'Select the type of public sector organisation you’re buying for'
        end
      end

      context 'and it is nil' do
        let(:sector) { nil }

        it 'is invalid and has the correct error message' do
          expect(buyer_detail).not_to be_valid(:update)
          expect(buyer_detail.errors[:sector].first).to eq 'Select the type of public sector organisation you’re buying for'
        end
      end

      context 'and it is not in the list' do
        let(:sector) { true }

        it 'is invalid and has the correct error message' do
          expect(buyer_detail).not_to be_valid(:update)
          expect(buyer_detail.errors[:sector].first).to eq 'Select the type of public sector organisation you’re buying for'
        end
      end

      context 'and it is in the list' do
        let(:sector) { 'government_policy' }

        it 'is valid' do
          expect(buyer_detail).to be_valid(:update)
        end
      end
    end

    context 'when considering contact_opt_in' do
      before { buyer_detail.contact_opt_in = contact_opt_in }

      context 'and it is blank' do
        let(:contact_opt_in) { '' }

        it 'is invalid and has the correct error message' do
          expect(buyer_detail).not_to be_valid(:update)
          expect(buyer_detail.errors[:contact_opt_in].first).to eq 'You must select an option'
        end
      end

      context 'and it is nil' do
        let(:contact_opt_in) { nil }

        it 'is invalid and has the correct error message' do
          expect(buyer_detail).not_to be_valid(:update)
          expect(buyer_detail.errors[:contact_opt_in].first).to eq 'You must select an option'
        end
      end

      context 'and it is true' do
        let(:contact_opt_in) { true }

        it 'is valid' do
          expect(buyer_detail).to be_valid(:update)
        end
      end

      context 'and it is false' do
        let(:contact_opt_in) { false }

        it 'is valid' do
          expect(buyer_detail).to be_valid(:update)
        end
      end
    end
  end

  describe '#full_organisation_address' do
    it 'returns the existing address without any extra commas' do
      expect(buyer_detail.full_organisation_address).to eq "#{buyer_detail.organisation_address_line_1}, #{buyer_detail.organisation_address_line_2}, #{buyer_detail.organisation_address_town}, #{buyer_detail.organisation_address_county} #{buyer_detail.organisation_address_postcode}"
    end

    it 'returns the existing address without address line 2 or county' do
      buyer_detail.organisation_address_line_2 = nil
      buyer_detail.organisation_address_county = nil
      expect(buyer_detail.full_organisation_address).to eq "#{buyer_detail.organisation_address_line_1}, #{buyer_detail.organisation_address_town} #{buyer_detail.organisation_address_postcode}"
    end
  end

  describe '#sector_name' do
    let(:result) { buyer_detail.sector_name }

    before { buyer_detail.sector = sector }

    context 'when sector is nil' do
      let(:sector) { nil }

      before { buyer_detail.central_government = central_government }

      context 'and central_government is true' do
        let(:central_government) { true }

        it 'returns Central government' do
          expect(result).to eq 'Central government'
        end
      end

      context 'and central_government is false' do
        let(:central_government) { false }

        it 'returns Wider public sector' do
          expect(result).to eq 'Wider public sector'
        end
      end
    end

    context 'when sector is defence_and_security' do
      let(:sector) { 'defence_and_security' }

      it 'returns Defence and Security' do
        expect(result).to eq 'Defence and Security'
      end
    end

    context 'when sector is health' do
      let(:sector) { 'health' }

      it 'returns Health' do
        expect(result).to eq 'Health'
      end
    end

    context 'when sector is government_policy' do
      let(:sector) { 'government_policy' }

      it 'returns Government Policy' do
        expect(result).to eq 'Government Policy'
      end
    end

    context 'when sector is local_community_and_housing' do
      let(:sector) { 'local_community_and_housing' }

      it 'returns Local Community and Housing' do
        expect(result).to eq 'Local Community and Housing'
      end
    end

    context 'when sector is infrastructure' do
      let(:sector) { 'infrastructure' }

      it 'returns Infrastructure' do
        expect(result).to eq 'Infrastructure'
      end
    end

    context 'when sector is education' do
      let(:sector) { 'education' }

      it 'returns Education' do
        expect(result).to eq 'Education'
      end
    end

    context 'when sector is culture_media_and_sport' do
      let(:sector) { 'culture_media_and_sport' }

      it 'returns Culture, Media and Sport' do
        expect(result).to eq 'Culture, Media and Sport'
      end
    end
  end

  describe '#details_complete?' do
    context 'when all attributes are there' do
      it 'returns true' do
        expect(buyer_detail.details_complete?).to be(true)
      end
    end

    context 'when some attributes are missing' do
      before { buyer_detail.full_name = nil }

      it 'returns true' do
        expect(buyer_detail.details_complete?).to be(false)
      end
    end
  end
end
