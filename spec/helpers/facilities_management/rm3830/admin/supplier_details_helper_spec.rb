require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SupplierDetailsHelper, type: :helper do
  let(:supplier) { create(:facilities_management_rm3830_admin_supplier_detail, **attributes) }
  let(:attributes) { {} }

  describe '.contact_detail' do
    context 'when considering the supplier_name' do
      it 'returns the supplier name' do
        expect(helper.contact_detail(:supplier_name, supplier)).to eq supplier.supplier_name
      end

      context 'and it is nil' do
        let(:attributes) { { supplier_name: nil } }

        it 'returns None' do
          expect(helper.contact_detail(:supplier_name, supplier)).to eq 'None'
        end
      end
    end

    context 'when considering the contact_name' do
      it 'returns the contact name' do
        expect(helper.contact_detail(:contact_name, supplier)).to eq supplier.contact_name
      end

      context 'and it is nil' do
        let(:attributes) { { contact_name: nil } }

        it 'returns None' do
          expect(helper.contact_detail(:contact_name, supplier)).to eq 'None'
        end
      end
    end

    context 'when considering the contact_email' do
      it 'returns the contact email' do
        expect(helper.contact_detail(:contact_email, supplier)).to eq supplier.contact_email
      end

      context 'and it is nil' do
        let(:attributes) { { contact_email: nil } }

        it 'returns None' do
          expect(helper.contact_detail(:contact_email, supplier)).to eq 'None'
        end
      end
    end

    context 'when considering the contact_phone' do
      it 'returns the contact email' do
        expect(helper.contact_detail(:contact_phone, supplier)).to eq supplier.contact_phone
      end

      context 'and it is nil' do
        let(:attributes) { { contact_phone: nil } }

        it 'returns None' do
          expect(helper.contact_detail(:contact_phone, supplier)).to eq 'None'
        end
      end
    end

    context 'when considering the duns' do
      it 'returns the duns' do
        expect(helper.contact_detail(:duns, supplier)).to eq supplier.duns
      end

      context 'and it is nil' do
        let(:attributes) { { duns: nil } }

        it 'returns None' do
          expect(helper.contact_detail(:duns, supplier)).to eq 'None'
        end
      end
    end

    context 'when considering the registration_number' do
      it 'returns the registration number' do
        expect(helper.contact_detail(:registration_number, supplier)).to eq supplier.registration_number
      end

      context 'and it is nil' do
        let(:attributes) { { registration_number: nil } }

        it 'returns None' do
          expect(helper.contact_detail(:registration_number, supplier)).to eq 'None'
        end
      end
    end
  end

  describe '.full_address' do
    before { @supplier = supplier }

    it 'returns the full_address' do
      expect(helper.full_address).to eq '17 Sailors road, Floor 2, Southend-On-Sea, Essex SS84 6VF'
    end

    context 'and it is nil' do
      let(:attributes) { { address_line_1: nil, address_line_2: nil, address_town: nil, address_county: nil, address_postcode: nil } }

      it 'returns None' do
        expect(helper.full_address).to eq 'None'
      end
    end
  end

  describe '.supplier_user_email' do
    before { @supplier = supplier }

    context 'and the supplier has a user' do
      let(:attributes) { { user: user } }
      let(:user) { create(:user) }

      it 'returns the supplier user email' do
        expect(helper.supplier_user_email).to eq user.email
      end
    end

    context 'and it is nil' do
      it 'returns None' do
        expect(helper.supplier_user_email).to eq 'None'
      end
    end
  end

  describe '.current_supplier_name' do
    let!(:origional_supplier_name) { supplier.supplier_name }

    before { helper.params[:id] = supplier.supplier_id }

    context 'when the supplier name is unchanged' do
      it 'returns the origional supplier name' do
        expect(helper.current_supplier_name).to eq origional_supplier_name
      end
    end

    context 'when the supplier name is changed on the model but not in the database' do
      it 'returns the origional supplier name' do
        supplier.supplier_name = 'Cuthbert'

        expect(helper.current_supplier_name).to eq origional_supplier_name
      end
    end
  end
end
