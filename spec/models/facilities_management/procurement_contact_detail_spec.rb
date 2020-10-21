require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementContactDetail, type: :model do
  let(:procurement_contact_detail) { create(:facilities_management_procurement_contact_detail) }

  describe '#validations' do
    context 'when everything is present' do
      it 'is valid' do
        expect(procurement_contact_detail.valid?).to eq true
      end
    end
  end

  describe '#name' do
    context 'when the name is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.name = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq false
      end
    end

    context 'when the name contain characters: .' do
      it 'expected to be valid' do
        procurement_contact_detail.name = 'James .Junior'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
      end
    end

    context 'when the name is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
      end

      it 'expected full_name alias to be valid' do
        expect(procurement_contact_detail.name).to eq procurement_contact_detail.full_name
      end
    end

    context 'when the name is 50 character long' do
      it 'expected to be valid' do
        procurement_contact_detail.name = 'Hubert Blaine Wolfeschlegelsteinhausenbergerdorff'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
      end
    end

    context 'when the name is 53 character long' do
      it 'expected to be invalid' do
        procurement_contact_detail.name = 'Hubert Blaine Wolfeschlegelsteinhausenbergerdorff Sr'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq false
      end
    end
  end

  describe '#job_title' do
    context 'when the job_title is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.job_title = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq false
      end
    end

    context 'when the job_title is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
      end
    end

    context 'when the job_title is 151 character long' do
      it 'expected to be invalid' do
        procurement_contact_detail.job_title = 'WolfeschlegelsteinhausenbergerdorffWolfeschlegelsteinhausenbergerdorWolfeschlegelsteinhausenbergerdorausenbergerdorffWolfeschlegelsteinhausenbergerdada'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq false
      end
    end

    context 'when the job_title is 150 character long' do
      it 'expected to be valid' do
        procurement_contact_detail.job_title = 'WolfeschlegelsteinhausenbergerdorffWolfeschlegelsteinhausenbergerdorWolfeschlegelsteinhausenbergerdorausenbergerdorffWolfeschlegelsteinhausenbergerdad'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
      end
    end
  end

  describe '#email' do
    context 'when the email is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.email = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq false
      end
    end

    context 'when the email is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
      end
    end
  end

  describe '#organisation_address_line_1' do
    context 'when the organisation_address_line_1 is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_line_1 = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq false
      end
    end

    context 'when the organisation_address_line_1 is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq true
      end
    end
  end

  describe '#organisation_address_town' do
    context 'when the organisation_address_town is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_town = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq false
      end
    end

    context 'when the organisation_address_town is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq true
      end
    end
  end

  describe '#organisation_address_postcode' do
    context 'when the organisation_address_postcode is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_postcode = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq false
      end
    end

    context 'when the organisation_address_postcode is valid' do
      it 'expected to be valid' do
        procurement_contact_detail.organisation_address_postcode = 'SE1 0PY'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq true

        procurement_contact_detail.organisation_address_postcode = 'N4 2DQ'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq true
      end
    end

    context 'when the organisation_address_postcode is invalid' do
      it 'expected to be valid' do
        procurement_contact_detail.organisation_address_postcode = 'SAN TA1'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq false
      end
    end

    context 'when the organisation_address_postcode is invalid with invalid symbol' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_postcode = 'ST! 2DE'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq false

        procurement_contact_detail.organisation_address_postcode = 'ST! @DE'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq false

        procurement_contact_detail.organisation_address_postcode = 'SW1A 1AA!'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details_address)).to eq false
      end
    end

    describe '#full_organisation_address' do
      context 'when verify full  is present' do
        it 'expected to be valid' do
          expect(procurement_contact_detail.full_organisation_address).to include(procurement_contact_detail.organisation_address_line_1)
        end
      end
    end
  end
end
