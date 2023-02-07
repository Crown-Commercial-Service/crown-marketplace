require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurements::ContractDetailsHelper do
  let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

  before { @procurement = procurement }

  describe '.show_page_content' do
    let(:result) { helper.show_page_content }
    let(:page_description) { instance_double(FacilitiesManagement::PageDetail::PageDescription) }

    before do
      @page_name = page_name
      @page_description = page_description
    end

    context 'when the state is pricing' do
      let(:page_name) { :pricing }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement, false, true, true]
      end
    end

    context 'when the state is what_next' do
      let(:page_name) { :what_next }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement, false, true, true]
      end
    end

    context 'when the state is important_information' do
      let(:page_name) { :important_information }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement, false, true, true]
      end
    end

    context 'when the state is contract_details' do
      let(:page_name) { :contract_details }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement, false, true]
      end
    end

    context 'when the state is review_and_generate' do
      let(:page_name) { :review_and_generate }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement, false, true, true]
      end
    end

    context 'when the state is review' do
      let(:page_name) { :review }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement, false, true, true]
      end
    end

    context 'when the state is sending' do
      let(:page_name) { :sending }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement, false, true, true]
      end
    end

    context 'when the state is sent' do
      let(:page_name) { :sent }

      it 'returns the correct options' do
        expect(result).to eq [page_description, procurement]
      end
    end
  end

  describe '.sorted_supplier_list' do
    let(:suppliers) do
      [
        { supplier_name: 'Abernathy and Sons', supplier_id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', direct_award_value: 12345 },
        { supplier_name: 'Marvin, Kunde and Cartwright', supplier_id: '31a9cca0-fc28-4022-8bb2-12d99d515153', direct_award_value: 1600000 },
        { supplier_name: 'Kunze, Langworth and Parisian', supplier_id: '18db95f9-2c20-4fbf-8f08-fb2e1e5eba94', direct_award_value: 1234567 },
        { supplier_name: 'Dare, Heaney and Kozey', supplier_id: '4dbe4d9c-37bb-4bd6-a8a7-35e36cf99f64', direct_award_value: 123456 }
      ]
    end

    before do
      suppliers.each do |supplier|
        procurement.procurement_suppliers.create(direct_award_value: supplier[:direct_award_value], supplier_id: supplier[:supplier_id])
      end
    end

    it 'provides the sorted list' do
      expect(helper.sorted_supplier_list).to eq([
                                                  { price: 12345, name: 'Abernathy and Sons' },
                                                  { price: 123456, name: 'Dare, Heaney and Kozey' },
                                                  { price: 1234567, name: 'Kunze, Langworth and Parisian' }
                                                ])
    end
  end

  describe '.supplier_plural' do
    let(:supplier_plural) { helper.supplier_plural }

    before do
      suppliers.each do |supplier|
        procurement.procurement_suppliers.create(direct_award_value: supplier[:direct_award_value], supplier_id: supplier[:supplier_id])
      end
    end

    context 'when there are multiple suppliers' do
      let(:suppliers) do
        [
          { supplier_name: 'Abernathy and Sons', supplier_id: 'ca57bf4c-e8a5-468a-95f4-39fcf730c770', direct_award_value: 12345 },
          { supplier_name: 'Marvin, Kunde and Cartwright', supplier_id: '31a9cca0-fc28-4022-8bb2-12d99d515153', direct_award_value: 1600000 },
          { supplier_name: 'Kunze, Langworth and Parisian', supplier_id: '18db95f9-2c20-4fbf-8f08-fb2e1e5eba94', direct_award_value: 1234567 },
          { supplier_name: 'Dare, Heaney and Kozey', supplier_id: '4dbe4d9c-37bb-4bd6-a8a7-35e36cf99f64', direct_award_value: 123456 }
        ]
      end

      it 'returns suppliers' do
        expect(supplier_plural).to eq 'suppliers'
      end
    end

    context 'when there is only one eligable supplier' do
      let(:suppliers) do
        [
          { supplier_name: 'Marvin, Kunde and Cartwright', supplier_id: '31a9cca0-fc28-4022-8bb2-12d99d515153', direct_award_value: 1600000 },
          { supplier_name: 'Kunze, Langworth and Parisian', supplier_id: '18db95f9-2c20-4fbf-8f08-fb2e1e5eba94', direct_award_value: 1234567 },
        ]
      end

      it 'returns supplier' do
        expect(supplier_plural).to eq 'supplier'
      end
    end
  end

  describe '.object_name' do
    let(:result) { helper.object_name(name) }

    context 'when given facilities_management_rm3830_procurement[invoice_contact_detail_attributes]' do
      let(:name) { 'facilities_management_rm3830_procurement[invoice_contact_detail_attributes]' }

      it 'returns facilities_management_rm3830_procurement_invoice_contact_detail_attributes' do
        expect(result).to eq 'facilities_management_rm3830_procurement_invoice_contact_detail_attributes'
      end
    end

    context 'when given facilities_management_rm3830_procurement[authorised_contact_detail_attributes]' do
      let(:name) { 'facilities_management_rm3830_procurement[authorised_contact_detail_attributes]' }

      it 'returns facilities_management_rm3830_procurement_authorised_contact_detail_attributes' do
        expect(result).to eq 'facilities_management_rm3830_procurement_authorised_contact_detail_attributes'
      end
    end

    context 'when given facilities_management_rm3830_procurement[notices_contact_detail_attributes]' do
      let(:name) { 'facilities_management_rm3830_procurement[notices_contact_detail_attributes]' }

      it 'returns facilities_management_rm3830_procurement_notices_contact_detail_attributes' do
        expect(result).to eq 'facilities_management_rm3830_procurement_notices_contact_detail_attributes'
      end
    end
  end

  describe '.security_policy_document_file_type' do
    let(:invalid_file) { Tempfile.new(['invalid_file', '.xlsx']) }
    let(:valid_xlsx_file_path) { fixture_file_upload(valid_xlsx_file.path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    before { procurement.update(security_policy_document_file: file_path) }

    after { file.unlink }

    context 'when the file is a pdf' do
      let(:file) { Tempfile.new(['security_policy_document_file', '.pdf']) }
      let(:file_path) { fixture_file_upload(file.path, 'application/pdf') }

      it 'returns pdf' do
        expect(helper.security_policy_document_file_type).to eq :pdf
      end
    end

    context 'when the file is a doc' do
      let(:file) { Tempfile.new(['security_policy_document_file', '.doc']) }
      let(:file_path) { fixture_file_upload(file.path, 'application/msword') }

      it 'returns doc' do
        expect(helper.security_policy_document_file_type).to eq :doc
      end
    end

    context 'when the file is a docx' do
      let(:file) { Tempfile.new(['security_policy_document_file', '.docx']) }
      let(:file_path) { fixture_file_upload(file.path, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') }

      it 'returns doc' do
        expect(helper.security_policy_document_file_type).to eq :doc
      end
    end
  end
end
