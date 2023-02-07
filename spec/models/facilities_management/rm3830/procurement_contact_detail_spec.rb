require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementContactDetail do
  let(:procurement_contact_detail) { create(:facilities_management_rm3830_procurement_contact_detail) }

  describe '#validations' do
    context 'when everything is present' do
      it 'is valid' do
        expect(procurement_contact_detail.valid?).to be true
      end
    end
  end

  describe '#name' do
    context 'when the name is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.name = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be false
      end
    end

    context 'when the name contain characters: .' do
      it 'expected to be valid' do
        procurement_contact_detail.name = 'James .Junior'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be true
      end
    end

    context 'when the name is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be true
      end

      it 'expected full_name alias to be valid' do
        expect(procurement_contact_detail.name).to eq procurement_contact_detail.full_name
      end
    end

    context 'when the name is 50 character long' do
      it 'expected to be valid' do
        procurement_contact_detail.name = 'Hubert Blaine Wolfeschlegelsteinhausenbergerdorff'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be true
      end
    end

    context 'when the name is 53 character long' do
      it 'expected to be invalid' do
        procurement_contact_detail.name = 'Hubert Blaine Wolfeschlegelsteinhausenbergerdorff Sr'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be false
      end
    end
  end

  describe '#job_title' do
    context 'when the job_title is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.job_title = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be false
      end
    end

    context 'when the job_title is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be true
      end
    end

    context 'when the job_title is 151 character long' do
      it 'expected to be invalid' do
        procurement_contact_detail.job_title = 'WolfeschlegelsteinhausenbergerdorffWolfeschlegelsteinhausenbergerdorWolfeschlegelsteinhausenbergerdorausenbergerdorffWolfeschlegelsteinhausenbergerdada'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be false
      end
    end

    context 'when the job_title is 150 character long' do
      it 'expected to be valid' do
        procurement_contact_detail.job_title = 'WolfeschlegelsteinhausenbergerdorffWolfeschlegelsteinhausenbergerdorWolfeschlegelsteinhausenbergerdorausenbergerdorffWolfeschlegelsteinhausenbergerdad'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be true
      end
    end
  end

  describe '#email' do
    context 'when the email is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.email = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be false
      end
    end

    context 'when the email is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to be true
      end
    end
  end

  %i[new_invoicing_contact_details_address new_authorised_representative_address new_notices_contact_details_address].each do |contact_detail|
    describe "add address validation for #{contact_detail}" do
      context 'when considering organisation_address_line_1' do
        before { procurement_contact_detail.organisation_address_line_1 = organisation_address_line_1 }

        context 'and it is blank' do
          let(:organisation_address_line_1) { nil }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end

          it 'has the correct error mesage' do
            procurement_contact_detail.valid?(contact_detail)

            expect(procurement_contact_detail.errors[:organisation_address_line_1].first).to eq 'Enter the building or street name of the address'
          end
        end

        context 'and it is empty' do
          let(:organisation_address_line_1) { '  ' }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end

          it 'has the correct error mesage' do
            procurement_contact_detail.valid?(contact_detail)

            expect(procurement_contact_detail.errors[:organisation_address_line_1].first).to eq 'Enter the building or street name of the address'
          end
        end

        context 'and it is more than the max characters' do
          let(:organisation_address_line_1) { 'a' * 256 }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end
        end

        context 'and it is in a valid form' do
          let(:organisation_address_line_1) { 'The Tardis' }

          it 'is valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be true
          end
        end
      end

      context 'when considering organisation_address_line_2' do
        before { procurement_contact_detail.organisation_address_line_2 = organisation_address_line_2 }

        context 'and it is more than the max characters' do
          let(:organisation_address_line_2) { 'a' * 256 }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end
        end

        context 'and it is in a valid form' do
          let(:organisation_address_line_2) { 'Gallifrey' }

          it 'is valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be true
          end
        end
      end

      context 'when considering organisation_address_town' do
        before { procurement_contact_detail.organisation_address_town = organisation_address_town }

        context 'and it is blank' do
          let(:organisation_address_town) { nil }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end

          it 'has the correct error mesage' do
            procurement_contact_detail.valid?(contact_detail)

            expect(procurement_contact_detail.errors[:organisation_address_town].first).to eq 'Enter the town or city of the address'
          end
        end

        context 'and it is empty' do
          let(:organisation_address_town) { '  ' }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end

          it 'has the correct error mesage' do
            procurement_contact_detail.valid?(contact_detail)

            expect(procurement_contact_detail.errors[:organisation_address_town].first).to eq 'Enter the town or city of the address'
          end
        end

        context 'and it is more than the max characters' do
          let(:organisation_address_town) { 'a' * 256 }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end
        end

        context 'and it is in a valid form' do
          let(:organisation_address_town) { 'Kasterborous' }

          it 'is valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be true
          end
        end
      end

      context 'when considering organisation_address_county' do
        before { procurement_contact_detail.organisation_address_county = organisation_address_county }

        context 'and it is more than the max characters' do
          let(:organisation_address_county) { 'a' * 256 }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end
        end

        context 'and it is in a valid form' do
          let(:organisation_address_county) { 'The Milky Way' }

          it 'is valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be true
          end
        end
      end
    end
  end

  %i[new_invoicing_contact_details_address new_authorised_representative_address new_notices_contact_details_address new_invoicing_contact_details new_authorised_representative new_notices_contact_details].each do |contact_detail|
    describe "postcode validations for #{contact_detail}" do
      before { procurement_contact_detail.organisation_address_postcode = organisation_address_postcode }

      context 'when the postcode is not present' do
        let(:organisation_address_postcode) { nil }

        it 'is invalid' do
          expect(procurement_contact_detail.valid?(contact_detail)).to be false
        end

        it 'has the correct error message' do
          procurement_contact_detail.valid?(contact_detail)

          expect(procurement_contact_detail.errors[:organisation_address_postcode].first).to eq 'Enter a valid postcode, for example SW1A 1AA'
        end
      end

      context 'when the postcode is not a valid postcode' do
        let(:organisation_address_postcode) { 'SA3 1TA NW14' }

        it 'is invalid' do
          expect(procurement_contact_detail.valid?(contact_detail)).to be false
        end

        it 'has the correct error message' do
          procurement_contact_detail.valid?(contact_detail)

          expect(procurement_contact_detail.errors[:organisation_address_postcode].first).to eq 'Enter a valid postcode, for example SW1A 1AA'
        end
      end

      context 'when the postcode is correct' do
        let(:organisation_address_postcode) { 'SA3 1TA' }

        it 'is valid' do
          expect(procurement_contact_detail.valid?(contact_detail)).to be true
        end
      end
    end
  end

  %i[new_invoicing_contact_details new_authorised_representative new_notices_contact_details].each do |contact_detail|
    describe "address selection for #{contact_detail}" do
      let(:organisation_address_postcode) { 'ST161AA' }
      let(:organisation_address_line_1) { 'The Globe Theatre' }
      let(:organisation_address_town) { 'London Town' }

      before { procurement_contact_detail.assign_attributes(organisation_address_postcode: organisation_address_postcode, organisation_address_line_1: organisation_address_line_1, organisation_address_town: organisation_address_town) }

      context 'when the postcode is not valid' do
        let(:organisation_address_postcode) { '' }

        it 'is not valid' do
          expect(procurement_contact_detail.valid?(contact_detail)).to be false
        end

        it 'does not have an error message on address selection' do
          procurement_contact_detail.valid?(contact_detail)
          expect(procurement_contact_detail.errors[:base].any?).to be false
        end
      end

      context 'when the postocde is valid' do
        context 'and address_line_1 is missing' do
          let(:organisation_address_line_1) { '' }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end

          it 'has the correct error message' do
            procurement_contact_detail.valid?(contact_detail)
            expect(procurement_contact_detail.errors[:base].first).to eq 'Select an address from the list or add a missing address'
          end
        end

        context 'and address_town is missing' do
          let(:organisation_address_town) { '' }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end

          it 'has the correct error message' do
            procurement_contact_detail.valid?(contact_detail)
            expect(procurement_contact_detail.errors[:base].first).to eq 'Select an address from the list or add a missing address'
          end
        end

        context 'and address_line_1 and address_town are missing' do
          let(:organisation_address_line_1) { '' }
          let(:organisation_address_town) { '' }

          it 'is not valid' do
            expect(procurement_contact_detail.valid?(contact_detail)).to be false
          end

          it 'has the correct error message' do
            procurement_contact_detail.valid?(contact_detail)
            expect(procurement_contact_detail.errors[:base].first).to eq 'Select an address from the list or add a missing address'
          end
        end
      end

      context 'when all parts are valid' do
        it 'is valid' do
          expect(procurement_contact_detail.valid?(contact_detail)).to be true
        end
      end
    end
  end

  describe '#full_organisation_address' do
    context 'when the full is present' do
      it 'expected to include organisation_address_line_1' do
        expect(procurement_contact_detail.full_organisation_address).to include(procurement_contact_detail.organisation_address_line_1)
      end
    end
  end
end
