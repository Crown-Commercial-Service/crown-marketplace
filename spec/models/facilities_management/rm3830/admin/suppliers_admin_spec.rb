require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SuppliersAdmin do
  subject(:suppliers_admin) { described_class.find(supplier_id) }

  let(:supplier_id) { 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }

  describe '.replace_services_for_lot' do
    let(:target_lot) { '1b' }
    let(:changed_lot_data) { suppliers_admin.lot_data[target_lot] }

    context 'when there are services selected' do
      let(:new_services) { %w[bish bosh bash] }

      before { suppliers_admin.replace_services_for_lot(new_services, target_lot) }

      it 'modifies services of correct lot' do
        expect(changed_lot_data['services']).to eq(new_services)
      end
    end

    context 'when there are no services selected' do
      let(:new_services) { nil }

      before { suppliers_admin.replace_services_for_lot(new_services, target_lot) }

      it 'modifies services to be an empty array' do
        expect(changed_lot_data['services']).to eq([])
      end
    end
  end

  describe 'validations' do
    let(:supplier) { create(:facilities_management_rm3830_admin_supplier_detail) }

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
        let(:existing_supplier) { create(:facilities_management_rm3830_admin_supplier_detail) }
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

    context 'when considering the contact_email' do
      before { supplier.contact_email = contact_email }

      context 'and not a valid format' do
        let(:contact_email) { 'invalid@email' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and is nil' do
        let(:contact_email) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and is empty' do
        let(:contact_email) { '' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and is white space' do
        let(:contact_email) { '   ' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and is a vlaid format' do
        let(:contact_email) { 'valid@email.test' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be true
        end
      end
    end

    context 'when considering the contact_name' do
      before { supplier.contact_name = contact_name }

      context 'and is nil' do
        let(:contact_name) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_name].first).to eq 'You must enter a name for the contact'
        end
      end

      context 'and is empty' do
        let(:contact_name) { '' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_name].first).to eq 'You must enter a name for the contact'
        end
      end

      context 'and is white space' do
        let(:contact_name) { '   ' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_name].first).to eq 'You must enter a name for the contact'
        end
      end

      context 'and is more than max chracters' do
        let(:contact_name) { 'Rose Tyler' * 11 }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_name].first).to eq 'The contact name cannot be more than 100 characters'
        end
      end

      context 'and is present' do
        let(:contact_name) { 'John Smith' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be true
        end
      end
    end

    context 'when considering the contact_phone' do
      before { supplier.contact_phone = contact_phone }

      context 'and is nil' do
        let(:contact_phone) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_phone].first).to eq 'You must enter a telephone number for the contact'
        end
      end

      context 'and is empty' do
        let(:contact_phone) { '' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_phone].first).to eq 'You must enter a telephone number for the contact'
        end
      end

      context 'and is white space' do
        let(:contact_phone) { '   ' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_phone].first).to eq 'You must enter a telephone number for the contact'
        end
      end

      context 'and contains invalid characters' do
        let(:contact_phone) { '0.hgm762' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_phone].first).to eq 'Enter a UK telephone number, for example 020 7946 0000'
        end
      end

      context 'and contains less than 9 numbers' do
        let(:contact_phone) { '01234567' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_phone].first).to eq 'Enter a UK telephone number, for example 020 7946 0000'
        end
      end

      context 'and contains more than 11 numbers' do
        let(:contact_phone) { '0123456789012' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_phone].first).to eq 'Enter a UK telephone number, for example 020 7946 0000'
        end
      end

      context 'and the total length is more than 15 characters' do
        let(:contact_phone) { '0-1-7-6-5-4-6-7-9-1-2' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_contact_information)
          expect(supplier.errors[:contact_phone].first).to eq 'The telephone number cannot be more than 15 characters'
        end
      end

      context 'and is just numbers in the valid format' do
        let(:contact_phone) { '01765467912' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be true
        end
      end

      context 'and is contains spaces in the valid format' do
        let(:contact_phone) { '01765 467 912' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be true
        end
      end

      context 'and is contains other characters in the valid format' do
        let(:contact_phone) { '(01765) 467 912' }

        it 'is valid' do
          expect(supplier.valid?(:supplier_contact_information)).to be true
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

    context 'when considering user email' do
      before { supplier.user_email = user_email }

      context 'and not a valid format' do
        let(:user_email) { 'invalid@email' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_user)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_user)
          expect(supplier.errors[:user_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and is nil' do
        let(:user_email) { nil }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_user)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_user)
          expect(supplier.errors[:user_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and is empty' do
        let(:user_email) { '' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_user)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_user)
          expect(supplier.errors[:user_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and is white space' do
        let(:user_email) { '   ' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_user)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_user)
          expect(supplier.errors[:user_email].first).to eq 'Enter an email address in the correct format, for example name@organisation.gov.uk'
        end
      end

      context 'and there is no user with that email' do
        let(:user_email) { 'valid@email.com' }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_user)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_user)
          expect(supplier.errors[:user_email].first).to eq 'The supplier must be registered with the facilities management service'
        end
      end

      context 'and the user does not have supplier access' do
        let(:user) { create(:user) }
        let(:user_email) { user.email }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_user)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_user)
          expect(supplier.errors[:user_email].first).to eq 'The user must have supplier access'
        end
      end

      context 'and the user belongs to another supplier' do
        let(:user) { create(:user, roles: :supplier) }
        let(:user_email) { user.email }

        before { described_class.find('ef44b65d-de46-4297-8d2c-2c6130cecafc').update(user:) }

        it 'is not valid' do
          expect(supplier.valid?(:supplier_user)).to be false
        end

        it 'has the correct error message' do
          supplier.valid?(:supplier_user)
          expect(supplier.errors[:user_email].first).to eq 'The user cannot belong to another supplier'
        end
      end

      context 'and the user is not changed' do
        let(:user) { create(:user, roles: :supplier) }
        let(:user_email) { user.email }

        before do
          supplier.update(user:)
          supplier.user_email = user_email
        end

        it 'is valid' do
          expect(supplier.valid?(:supplier_user)).to be true
        end
      end

      context 'and it is an unasigned user' do
        let(:user) { create(:user, roles: :supplier) }
        let(:user_email) { user.email }

        it 'is valid' do
          expect(supplier.valid?(:supplier_user)).to be true
        end
      end
    end
  end

  describe '.user_information_required?' do
    let(:supplier) { create(:facilities_management_rm3830_admin_supplier_detail) }

    it 'returns true' do
      expect(supplier.user_information_required?).to be true
    end
  end

  describe '.suspendable?' do
    let(:supplier) { create(:facilities_management_rm3830_admin_supplier_detail) }

    it 'returns false' do
      expect(supplier.suspendable?).to be false
    end
  end
end
