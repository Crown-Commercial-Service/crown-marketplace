require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Journey::InformationAboutYourRequirements do
  let(:information_about_your_requirements) { described_class.new(contract_start_date_dd:, contract_start_date_mm:, contract_start_date_yyyy:, estimated_contract_duration:, private_finance_initiative:) }
  let(:contract_start_date) { Time.now.in_time_zone('London') + 1.year }
  let(:contract_start_date_dd) { contract_start_date.day }
  let(:contract_start_date_mm) { contract_start_date.month }
  let(:contract_start_date_yyyy) { contract_start_date.year }
  let(:estimated_contract_duration) { 3 }
  let(:private_finance_initiative) { 'yes' }

  describe 'validations' do
    context 'when no contract start date is present' do
      let(:contract_start_date_dd) { nil }
      let(:contract_start_date_mm) { nil }
      let(:contract_start_date_yyyy) { nil }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:contract_start_date].first).to eq 'Enter a real date, for example 25 12 2027'
      end
    end

    context 'when contract start date is in the past' do
      let(:contract_start_date) { Time.now.in_time_zone('London') - 1.day }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:contract_start_date].first).to eq 'The estimated start date must be in the future'
      end
    end

    context 'when contract start date is not valid' do
      let(:contract_start_date_dd) { 47 }
      let(:contract_start_date_mm) { 67 }
      let(:contract_start_date_yyyy) { 4 }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:contract_start_date].first).to eq 'Enter a real date, for example 25 12 2027'
      end
    end

    context 'when estimated contract duration is not under 100 years' do
      let(:estimated_contract_duration) { 456 }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:estimated_contract_duration].first).to eq 'The estimated contract duration must be less than 100'
      end
    end

    context 'when the estimated contract duration is 100 years' do
      let(:estimated_contract_duration) { 100 }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:estimated_contract_duration].first).to eq 'The estimated contract duration must be less than 100'
      end
    end

    context 'when the estimated contract duration is not more than 0 years' do
      let(:estimated_contract_duration) { 0 }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:estimated_contract_duration].first).to eq 'The estimated contract duration must be a whole number greater than 0'
      end
    end

    context 'when estimated contract duration is not a number' do
      let(:estimated_contract_duration) { 'k' }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:estimated_contract_duration].first).to eq 'The estimated contract duration must be a whole number greater than 0'
      end
    end

    context 'when estimated contract duration is not an integer' do
      let(:estimated_contract_duration) { 9.3 }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:estimated_contract_duration].first).to eq 'The estimated contract duration must be a whole number greater than 0'
      end
    end

    context 'when no estimated contract duration is present' do
      let(:estimated_contract_duration) { nil }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:estimated_contract_duration].first).to eq 'The estimated contract duration must be a whole number greater than 0'
      end
    end

    context 'when no private finance initiative is present' do
      let(:private_finance_initiative) { nil }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:private_finance_initiative].first).to eq 'Select one option for requirements linked to PFI'
      end
    end

    context 'when private finance initiative answer is not yes or no' do
      let(:private_finance_initiative) { 'ten' }

      it 'is not valid and has the correct error message' do
        expect(information_about_your_requirements.valid?).to be false
        expect(information_about_your_requirements.errors[:private_finance_initiative].first).to eq 'Select one option for requirements linked to PFI'
      end
    end

    context 'when everything is present' do
      it 'is valid' do
        expect(information_about_your_requirements.valid?).to be true
      end
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::Procurement' do
      expect(information_about_your_requirements.next_step_class).to be FacilitiesManagement::RM6378::Journey::Procurement
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:contract_start_date_dd, :contract_start_date_mm, :contract_start_date_yyyy, :estimated_contract_duration, :private_finance_initiative, {}]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[contract_start_date_dd contract_start_date_mm contract_start_date_yyyy estimated_contract_duration private_finance_initiative]
    end
  end

  describe '.slug' do
    it 'returns information-about-your-requirements' do
      expect(information_about_your_requirements.slug).to eq 'information-about-your-requirements'
    end
  end

  describe '.template' do
    it 'returns journey/information_about_your_requirements' do
      expect(information_about_your_requirements.template).to eq 'journey/information_about_your_requirements'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(information_about_your_requirements.final?).to be false
    end
  end
end
