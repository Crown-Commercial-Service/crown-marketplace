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

    context 'when the name uses invalid characters: @' do
      it 'expected to be invalid' do
        procurement_contact_detail.name = '@'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq false
      end
    end

    context 'when the name contain characters: .' do
      it 'expected to be valid' do
        procurement_contact_detail.name = 'James .Junior'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
      end
    end

    context 'when the name contain characters: ..' do
      it 'expected to be invalid' do
        procurement_contact_detail.name = 'James ..Junior'
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq false
      end
    end

    context 'when the name is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_contact_details)).to eq true
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

    context 'when the job_title uses invalid characters' do
      it 'expected to be invalid' do
        procurement_contact_detail.job_title = ' @ £ '
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

    context 'when the email uses invalid characters' do
      it 'expected to be invalid' do
        procurement_contact_detail.email = 'Chee@.com'
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
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq false
      end
    end

    context 'when the organisation_address_line_1 is uses invalid characters: ,' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_line_1 = '1, downing street'
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq false
      end
    end

    context 'when the organisation_address_line_1 uses invalid characters: @' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_line_1 = '1@ downing street'
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq false
      end
    end

    context 'when the organisation_address_line_1 is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq true
      end
    end
  end

  describe '#organisation_address_town' do
    context 'when the organisation_address_town is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_town = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq false
      end
    end

    context 'when the organisation_address_town uses invalid characters' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_town = 'town@'
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq false
      end
    end

    context 'when the organisation_address_town is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq true
      end
    end
  end

  describe '#organisation_address_postcode' do
    context 'when the organisation_address_postcode is only one space character' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_postcode = ' '
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq false
      end
    end

    context 'when the organisation_address_postcode uses invalid characters' do
      it 'expected to be invalid' do
        procurement_contact_detail.organisation_address_postcode = 'ab@10'
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq false
      end
    end

    context 'when the organisation_address_postcode is valid' do
      it 'expected to be valid' do
        expect(procurement_contact_detail.valid?(:new_invoicing_address)).to eq true
      end
    end
  end
end
