require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::FilesImporter do
  let(:upload) do
    create(:facilities_management_rm3830_admin_upload, aasm_state: 'in_progress') do |admin_upload|
      admin_upload.supplier_data_file.attach(io: File.open(supplier_data_file_path), filename: 'test_supplier_framework_date_file.xlsx')
    end
  end

  let(:supplier_data_file) { FacilitiesManagement::Admin::SupplierFrameworkData.new(**supplier_data_file_options) }
  let(:supplier_data_file_path) { FacilitiesManagement::Admin::SupplierFrameworkData::OUTPUT_PATH }
  let(:supplier_data_file_options) { {} }
  let(:files_importer) { described_class.new(upload) }

  before do
    supplier_data_file.build
    supplier_data_file.write

    files_importer.import_data
  end

  describe 'check_file' do
    context 'when the files have the wrong sheets' do
      let(:supplier_data_file_options) { { sheets: ['Prices', 'Variances', 'Discounts'] } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'supplier_data_missing_sheets' }]
      end
    end

    context 'when the sheets have the wrong headers' do
      let(:supplier_data_file_options) { { headers: FacilitiesManagement::Admin::SupplierFrameworkData::HEADERS.reverse } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'pricing_sheet_headers_incorrect' },
                                            { error: 'variances_sheet_headers_incorrect' }]
      end
    end
  end

  describe 'check_processed_data' do
    context 'when some rates are blank' do
      let(:supplier_data_file_options) { { error_type: :blank, normal_supplier: 'Kulas, Schultz and Moore' } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'prices_blank', details: ['Hirthe-Mills', 'Rowe, Hessel and Heller'] },
                                            { error: 'variances_blank', details: ['Hirthe-Mills'] }]
      end
    end

    context 'when some rates are not a number' do
      let(:supplier_data_file_options) { { error_type: :non_numerics, normal_supplier: 'Rowe, Hessel and Heller' } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'prices_not_a_number', details: ['Hirthe-Mills', 'Kulas, Schultz and Moore'] },
                                            { error: 'discounts_not_a_number', details: ['Hirthe-Mills', 'Kulas, Schultz and Moore'] },
                                            { error: 'variances_not_a_number', details: ['Hirthe-Mills', 'Kulas, Schultz and Moore'] }]
      end
    end

    context 'when some rates are less than 0' do
      let(:supplier_data_file_options) { { error_type: :greater_than, normal_supplier: 'Rowe, Hessel and Heller' } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'prices_greater_than_or_equal_to', details: ['Hirthe-Mills', 'Kulas, Schultz and Moore'] },
                                            { error: 'variances_greater_than_or_equal_to', details: ['Rowe, Hessel and Heller'] }]
      end
    end

    context 'when some rates are more than 100%' do
      let(:supplier_data_file_options) { { error_type: :less_than, normal_supplier: 'Hirthe-Mills' } }

      it 'changes the state to failed and has the correct errors' do
        expect(upload).to have_state(:failed)
        expect(upload.import_errors).to eq [{ error: 'prices_less_than_or_equal_to', details: ['Kulas, Schultz and Moore', 'Rowe, Hessel and Heller'] },
                                            { error: 'discounts_less_than_or_equal_to', details: ['Kulas, Schultz and Moore', 'Rowe, Hessel and Heller'] },
                                            { error: 'variances_less_than_or_equal_to', details: ['Kulas, Schultz and Moore'] }]
      end
    end
  end

  describe 'import_data' do
    let(:latest_rate_card_data) { FacilitiesManagement::RM3830::RateCard.latest.data }
    let(:supplier_prices) { latest_rate_card_data[:Prices][supplier_id] }
    let(:supplier_discounts) { latest_rate_card_data[:Discounts][supplier_id] }
    let(:supplier_variances) { latest_rate_card_data[:Variances][supplier_id].slice(*FacilitiesManagement::Admin::SupplierFrameworkData::HEADERS[1].map(&:to_sym)).values }

    it 'publishes the import' do
      expect(upload).to have_state(:published)
    end

    it 'has rates for all lot 1 supplier' do
      expect(latest_rate_card_data[:Prices].size).to eq 26
      expect(latest_rate_card_data[:Discounts].size).to eq 26
      expect(latest_rate_card_data[:Variances].size).to eq 26
    end

    it 'has left any other suppliers with blank rates' do
      expect(latest_rate_card_data[:Prices].count { |_, data| data.any? }).to eq 3
      expect(latest_rate_card_data[:Discounts].count { |_, data| data.any? }).to eq 3
      expect(latest_rate_card_data[:Variances].count { |_, data| data.any? }).to eq 3
    end

    def get_price_for_service(service_code)
      supplier_prices[service_code].slice(:'General office - Customer Facing', :'General office - Non Customer Facing', :'Call Centre Operations', :Warehouses, :'Restaurant and Catering Facilities', :'Pre-School', :'Primary School', :'Secondary Schools', :'Special Schools', :'Universities and Colleges', :'Community - Doctors, Dentist, Health Clinic', :'Nursing and Care Homes').values
    end

    def get_discount_for_service(service_code)
      supplier_discounts[service_code][:'Disc %']
    end

    context 'when considering just Hirthe-Mills' do
      let(:supplier_id) { :'097fc4ad-ffbb-4ced-bce5-74d4aee5bd02' }

      it 'has expected Prices' do
        expect(get_price_for_service(:'C.13')).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        expect(get_price_for_service(:'J.3')).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        expect(get_price_for_service(:'M.1')).to eq [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12]
      end

      it 'has expected Discounts' do
        expect(get_discount_for_service(:'C.13')).to eq 0.1
        expect(get_discount_for_service(:'J.3')).to eq 0.1
        expect(get_discount_for_service(:'M.1')).to eq 0.13
      end

      it 'has expected Variances' do
        expect(supplier_variances).to eq [0.1, 0.1, 0.1, 0.1, 1, 0.1, 0.1]
      end
    end

    context 'when considering just Kulas, Schultz and Moore' do
      let(:supplier_id) { :'e9a88008-e099-4724-abfe-a79b2e956ba7' }

      it 'has expected Prices' do
        expect(get_price_for_service(:'E.3')).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        expect(get_price_for_service(:'K.1')).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        expect(get_price_for_service(:'N.1')).to eq [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12]
      end

      it 'has expected Discounts' do
        expect(get_discount_for_service(:'E.2')).to eq 0.1
        expect(get_discount_for_service(:'K.1')).to eq 0.1
        expect(get_discount_for_service(:'N.1')).to eq 0.13
      end

      it 'has expected Variances' do
        expect(supplier_variances).to eq [0.2, 0.2, 0.2, 0.2, 2, 0.2, 0.2]
      end
    end

    context 'when considering just Rowe, Hessel and Heller' do
      let(:supplier_id) { :'ef44b65d-de46-4297-8d2c-2c6130cecafc' }

      it 'has expected Prices' do
        expect(get_price_for_service(:'G.2')).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        expect(get_price_for_service(:'H.4')).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        expect(get_price_for_service(:'O.1')).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      end

      it 'has expected Discounts' do
        expect(get_discount_for_service(:'G.2')).to eq 0.1
        expect(get_discount_for_service(:'H.4')).to eq 0.1
        expect(get_discount_for_service(:'O.1')).to eq 0.1
      end

      it 'has expected Variances' do
        expect(supplier_variances).to eq [0.3, 0.3, 0.3, 0.3, 3, 0.3, 0.3]
      end
    end
  end
end
