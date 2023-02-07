require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SuppliersAdmin do
  let(:supplier) { create(:facilities_management_rm6232_admin_suppliers_admin) }

  describe 'validations' do
    context 'when considering supplier name' do
      before { supplier.supplier_name = supplier_name }

      context 'and it is nil' do
        let(:supplier_name) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_name)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_name)
          expect(supplier.errors[:supplier_name].first).to eq 'You must enter a supplier name'
        end
      end

      context 'and it is empty' do
        let(:supplier_name) { '' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_name)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_name)
          expect(supplier.errors[:supplier_name].first).to eq 'You must enter a supplier name'
        end
      end

      context 'and it is blank space' do
        let(:supplier_name) { '    ' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_name)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_name)
          expect(supplier.errors[:supplier_name].first).to eq 'You must enter a supplier name'
        end
      end

      context 'and it is too long' do
        let(:supplier_name) { 'a' * 101 }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_name)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_name)
          expect(supplier.errors[:supplier_name].first).to eq 'The supplier name cannot be more than 100 characters'
        end
      end

      context 'and it belongs to another supplier' do
        let(:existing_supplier) { create(:facilities_management_rm6232_admin_suppliers_admin) }
        let(:supplier_name) { existing_supplier.supplier_name }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_name)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_name)
          expect(supplier.errors[:supplier_name].first).to eq 'A supplier with this name already exists'
        end
      end

      context 'and it meets the requirements' do
        let(:supplier_name) { 'Terry and sons' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_name)).to be true
        end
      end
    end

    context 'when considering the duns number' do
      before { supplier.duns = duns }

      context 'and is nil' do
        let(:duns) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:duns].first).to eq 'Enter the DUNS number'
        end
      end

      context 'and is empty' do
        let(:duns) { '' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:duns].first).to eq 'Enter the DUNS number'
        end
      end

      context 'and is white space' do
        let(:duns) { '   ' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:duns].first).to eq 'Enter the DUNS number'
        end
      end

      context 'and does not match the format' do
        let(:duns) { 'Random123' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:duns].first).to eq 'Enter the DUNS number in the correct format with 9 digits, for example 214567885'
        end
      end

      context 'and does not have enough digits' do
        let(:duns) { '12345678' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:duns].first).to eq 'Enter the DUNS number in the correct format with 9 digits, for example 214567885'
        end
      end

      context 'and has too many digits' do
        let(:duns) { '1234567890' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:duns].first).to eq 'Enter the DUNS number in the correct format with 9 digits, for example 214567885'
        end
      end

      context 'and is present' do
        let(:duns) { '123456789' }

        it 'is valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be true
        end
      end
    end

    context 'when considering the registration_number' do
      before { supplier.registration_number = registration_number }

      context 'and is nil' do
        let(:registration_number) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number'
        end
      end

      context 'and is empty' do
        let(:registration_number) { '' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number'
        end
      end

      context 'and is white space' do
        let(:registration_number) { '   ' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number'
        end
      end

      context 'and it is one character followed by 6 numbers' do
        let(:registration_number) { 'A123456' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number in the correct format, for example AC123456'
        end
      end

      context 'and it is two character followed by 5 numbers' do
        let(:registration_number) { 'AB12345' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number in the correct format, for example AC123456'
        end
      end

      context 'and it is three character followed by 5 numbers' do
        let(:registration_number) { 'ABC12345' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number in the correct format, for example AC123456'
        end
      end

      context 'and it is 5 numbers' do
        let(:registration_number) { '12345' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number in the correct format, for example AC123456'
        end
      end

      context 'and it is 9 numbers' do
        let(:registration_number) { '123456789' }

        it 'is not valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:additional_supplier_information)
          expect(supplier.errors[:registration_number].first).to eq 'Enter the company registration number in the correct format, for example AC123456'
        end
      end

      context 'and it is 2 characters followed by numbers' do
        let(:registration_number) { 'AB123456' }

        it 'is valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be true
        end
      end

      context 'and it is 6 numbers' do
        let(:registration_number) { '123456' }

        it 'is valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be true
        end
      end

      context 'and it is 7 numbers' do
        let(:registration_number) { '1234567' }

        it 'is valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be true
        end
      end

      context 'and it is 8 numbers' do
        let(:registration_number) { '12345678' }

        it 'is valid' do
          expect(supplier.valid?(:additional_supplier_information)).to be true
        end
      end
    end

    context 'when considering address_line_1' do
      before { supplier.address_line_1 = address_line_1 }

      context 'and it is blank' do
        let(:address_line_1) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_line_1].first).to eq 'Enter the building or street name'
        end
      end

      context 'and it is empty' do
        let(:address_line_1) { '  ' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_line_1].first).to eq 'Enter the building or street name'
        end
      end

      context 'and it is more than the max characters' do
        let(:address_line_1) { 'a' * 101 }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_line_1].first).to eq 'Building or street name must be 100 characters or less'
        end
      end

      context 'and it is in a valid form' do
        let(:address_line_1) { 'The Tardis' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_address)).to be true
        end
      end
    end

    context 'when considering address_line_2' do
      before { supplier.address_line_2 = address_line_2 }

      context 'and it is more than the max characters' do
        let(:address_line_2) { 'a' * 101 }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_line_2].first).to eq 'Second address line must be 100 characters or less'
        end
      end

      context 'and it is in a valid form' do
        let(:address_line_2) { 'Gallifrey' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_address)).to be true
        end
      end
    end

    context 'when considering address_town' do
      before { supplier.address_town = address_town }

      context 'and it is blank' do
        let(:address_town) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_town].first).to eq 'Enter the town or city'
        end
      end

      context 'and it is empty' do
        let(:address_town) { '  ' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_town].first).to eq 'Enter the town or city'
        end
      end

      context 'and it is more than the max characters' do
        let(:address_town) { 'a' * 51 }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_town].first).to eq 'The town or city name for this building must be 50 characters or less'
        end
      end

      context 'and it is in a valid form' do
        let(:address_town) { 'Kasterborous' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_address)).to be true
        end
      end
    end

    context 'when considering address_county' do
      before { supplier.address_county = address_county }

      context 'and it is more than the max characters' do
        let(:address_county) { 'a' * 51 }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error mesage' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_county].first).to eq 'The county must be 50 characters or less'
        end
      end

      context 'and it is in a valid form' do
        let(:address_county) { 'The Milky Way' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_address)).to be true
        end
      end
    end

    context 'when considering address_postcode' do
      before { supplier.address_postcode = address_postcode }

      context 'when the postcode is not present' do
        let(:address_postcode) { nil }

        it 'is invalid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_postcode].first).to eq 'Enter a valid postcode, for example SW1A 1AA'
        end
      end

      context 'when the postcode is not a valid postcode' do
        let(:address_postcode) { 'SA3 1TA NW14' }

        it 'is invalid' do
          expect(supplier.valid?(:supplier_address)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_address)

          expect(supplier.errors[:address_postcode].first).to eq 'Enter a valid postcode, for example SW1A 1AA'
        end
      end

      context 'when the postcode is correct' do
        let(:address_postcode) { 'SA3 1TA' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_address)).to be true
        end
      end
    end
  end

  context 'when considering supplier_status' do
    before { supplier.active = supplier_status }

    context 'when the status is nil' do
      let(:supplier_status) { nil }

      it 'is invalid' do
        expect(supplier.valid?(:supplier_status)).to be false
      end

      it 'has the correct error message' do
        supplier.valid?(:supplier_status)

        expect(supplier.errors[:active].first).to eq 'You must select a status for the supplier'
      end
    end

    context 'when the status is not present' do
      let(:supplier_status) { '' }

      it 'is invalid' do
        expect(supplier.valid?(:supplier_status)).to be false
      end

      it 'has the correct error message' do
        supplier.valid?(:supplier_status)

        expect(supplier.errors[:active].first).to eq 'You must select a status for the supplier'
      end
    end

    context 'when the status is true' do
      let(:supplier_status) { true }

      it 'is valid' do
        expect(supplier.valid?(:supplier_status)).to be true
      end
    end

    context 'when the status is false' do
      let(:supplier_status) { false }

      it 'is valid' do
        expect(supplier.valid?(:supplier_status)).to be true
      end
    end
  end

  describe '.user_information_required?' do
    it 'returns false' do
      expect(supplier.user_information_required?).to be false
    end
  end

  describe '.suspendable?' do
    it 'returns true' do
      expect(supplier.suspendable?).to be true
    end
  end

  describe '.current_status' do
    let(:supplier) { create(:facilities_management_rm6232_admin_suppliers_admin, active: active) }

    context 'when the supplier is active' do
      let(:active) { true }

      it 'returns blue and ACTIVE' do
        expect(supplier.current_status).to eq [:blue, 'ACTIVE']
      end
    end

    context 'when the supplier is not active' do
      let(:active) { false }

      it 'returns red and INACTIVE' do
        expect(supplier.current_status).to eq [:red, 'INACTIVE']
      end
    end
  end

  describe '.changed_data' do
    let(:result) { supplier.changed_data }

    before { supplier.update(**attributes) }

    context 'when changing the supplier status' do
      let(:attributes) { { active: false } }
      let(:data) do
        [
          {
            attribute: 'active',
            value: false
          }
        ]
      end

      it 'returns the correct data' do
        expect(result).to eq([supplier.id, :details, data])
      end
    end

    context 'when changing the supplier name' do
      let(:attributes) { { supplier_name: 'Vandaham Corp' } }
      let(:data) do
        [
          {
            attribute: 'supplier_name',
            value: 'Vandaham Corp'
          }
        ]
      end

      it 'returns the correct data' do
        expect(result).to eq([supplier.id, :details, data])
      end
    end

    context 'when changing the duns and CRN number' do
      let(:new_duns) { Faker::Company.unique.duns_number.gsub('-', '') }
      let(:attributes) { { duns: new_duns, registration_number: '0654321' } }
      let(:data) do
        [
          {
            attribute: 'duns',
            value: new_duns
          },
          {
            attribute: 'registration_number',
            value: '0654321'
          }
        ]
      end

      it 'returns the correct data' do
        expect(result).to eq([supplier.id, :details, data])
      end
    end

    context 'when changing the address' do
      let(:attributes) { { address_line_1: "Jakolo's Inn", address_line_2: supplier.address_line_2, address_town: 'Alba cavanich', address_county: supplier.address_county, address_postcode: supplier.address_postcode } }

      let(:data) do
        [
          {
            attribute: 'address_line_1',
            value: "Jakolo's Inn"
          },
          {
            attribute: 'address_town',
            value: 'Alba cavanich'
          }
        ]
      end

      it 'returns the correct data' do
        expect(result).to eq([supplier.id, :details, data])
      end
    end
  end
end
