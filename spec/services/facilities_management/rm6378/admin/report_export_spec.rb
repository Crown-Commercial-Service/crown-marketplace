require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Admin::ReportExport do
  let(:framework) { Framework.find('RM6378') }
  let(:other_framework) { create(:framework) }
  let(:user_1) { create(:user, :with_detail) }
  let(:user_2) { create(:user, :with_detail) }
  let(:user_3) { create(:user, :with_detail) }
  let(:procurement_1) { create(:facilities_management_rm6378_procurement, user: user_1, framework: framework, lot_id: 'RM6378.1a', created_at: 6.days.ago, procurement_details: { 'service_ids' => ['RM6378.1a.E1', 'RM6378.1a.E2'], 'jurisdiction_ids' => ['RM6378.TLH3', 'RM6378.TLH5'], 'annual_contract_value' => 12_345, 'contract_start_date_dd' => '1', 'contract_start_date_mm' => '1', 'contract_start_date_yyyy' => '2028', 'estimated_contract_duration' => 10, 'private_finance_initiative' => 'yes', 'contact_opt_in' => true }) }
  let(:procurement_2) { create(:facilities_management_rm6378_procurement, user: user_2, framework: framework, lot_id: 'RM6378.2a', created_at: 5.days.ago, procurement_details: { 'service_ids' => ['RM6378.2a.C13', 'RM6378.2a.C6'], 'jurisdiction_ids' => ['RM6378.TLH6', 'RM6378.TLL31'], 'annual_contract_value' => 28_363, 'contract_start_date_dd' => '6', 'contract_start_date_mm' => '3', 'contract_start_date_yyyy' => '2029', 'estimated_contract_duration' => 85, 'private_finance_initiative' => 'no', 'contact_opt_in' => false }) }
  let(:procurement_3) { create(:facilities_management_rm6378_procurement, user: user_3, framework: framework, lot_id: 'RM6378.3a', created_at: 4.days.ago, procurement_details: { 'service_ids' => ['RM6378.3a.J3', 'RM6378.3a.O8'], 'jurisdiction_ids' => ['RM6378.TLI6', 'RM6378.TLL34'], 'annual_contract_value' => 93_874, 'contract_start_date_dd' => '18', 'contract_start_date_mm' => '7', 'contract_start_date_yyyy' => '2028', 'estimated_contract_duration' => 53, 'private_finance_initiative' => 'no', 'contact_opt_in' => false }) }
  let(:procurement_4) { create(:facilities_management_rm6378_procurement, user: user_1, framework: framework, lot_id: 'RM6378.4a', created_at: 3.days.ago, procurement_details: { 'service_ids' => ['RM6378.4a.R1', 'RM6378.4a.U1'], 'jurisdiction_ids' => ['RM6378.TLH4', 'RM6378.TLN07'], 'annual_contract_value' => 61_062, 'contract_start_date_dd' => '25', 'contract_start_date_mm' => '11', 'contract_start_date_yyyy' => '2034', 'estimated_contract_duration' => 88, 'private_finance_initiative' => 'yes', 'contact_opt_in' => false }) }
  let(:procurement_5) { create(:facilities_management_rm6378_procurement, user: user_2, framework: framework, lot_id: 'RM6378.4b', created_at: 2.days.ago, procurement_details: { 'service_ids' => ['RM6378.4b.O4', 'RM6378.4b.O7'], 'jurisdiction_ids' => ['RM6378.TLC3', 'RM6378.TLL51'], 'annual_contract_value' => 19_176, 'contract_start_date_dd' => '19', 'contract_start_date_mm' => '8', 'contract_start_date_yyyy' => '2035', 'estimated_contract_duration' => 15, 'private_finance_initiative' => 'no', 'contact_opt_in' => true }) }
  let(:procurement_6) { create(:facilities_management_rm6378_procurement, user: user_3, framework: framework, lot_id: 'RM6378.4c', created_at: 1.day.ago, procurement_details: { 'service_ids' => ['RM6378.4c.P1', 'RM6378.4c.Q2'], 'jurisdiction_ids' => ['RM6378.TLE3', 'RM6378.TLM03'], 'annual_contract_value' => 58_348, 'contract_start_date_dd' => '14', 'contract_start_date_mm' => '6', 'contract_start_date_yyyy' => '2037', 'estimated_contract_duration' => 42, 'private_finance_initiative' => 'yes', 'contact_opt_in' => false }) }
  let(:procurement_7) { create(:facilities_management_rm6378_procurement, user: user_1, framework: framework, lot_id: 'RM6378.4d', created_at: Time.now.in_time_zone('London'), procurement_details: { 'service_ids' => ['RM6378.4d.T1', 'RM6378.4d.T2'], 'jurisdiction_ids' => ['RM6378.TLJ2', 'RM6378.TLN09'], 'annual_contract_value' => 89_858, 'contract_start_date_dd' => '12', 'contract_start_date_mm' => '7', 'contract_start_date_yyyy' => '2036', 'estimated_contract_duration' => 96, 'private_finance_initiative' => 'no', 'contact_opt_in' => false }) }
  let(:procurement_8) { create(:facilities_management_rm6378_procurement, user: user_1, framework: other_framework, lot_id: 'RM6378.1b', created_at: 3.days.ago, procurement_details: { 'service_ids' => ['RM6378.1b.C8', 'RM6378.1b.D12'], 'jurisdiction_ids' => ['RM6378.TLF1', 'RM6378.TLN0B'], 'annual_contract_value' => 68_554, 'contract_start_date_dd' => '16', 'contract_start_date_mm' => '1', 'contract_start_date_yyyy' => '2030', 'estimated_contract_duration' => 69, 'private_finance_initiative' => 'no', 'contact_opt_in' => true }) }

  before do
    allow(ReportWorker).to receive(:perform_async)
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(FacilitiesManagement::RM6378::Procurement).to receive(:search_result).and_return([['CHARLES', '1'], ['MABEL', '2'], ['OLIVER', '3']])
    # rubocop:enable RSpec/AnyInstance

    procurement_1
    procurement_2
    procurement_3
    procurement_4
    procurement_5
    procurement_6
    procurement_7
  end

  describe '.call' do
    let(:result) { described_class.call(report) }
    let(:report) { create(:report, framework: framework, start_date: 6.days.ago - 1.hour, end_date: Time.now.in_time_zone('London')) }

    it 'creates a CSV string' do
      expect(result).to be_a String
    end
  end

  describe '.find_searches' do
    let(:report) { create(:report, framework:, start_date:, end_date:) }
    let(:result) { described_class.send(:find_searches, report) }

    context 'when the date range includes all of the searches' do
      let(:start_date) { 6.days.ago - 1.hour }
      let(:end_date) { Time.now.in_time_zone('London') }

      it 'returns all of the searches belonging to the framework' do
        expect(result).to eq([procurement_7, procurement_6, procurement_5, procurement_4, procurement_3, procurement_2, procurement_1])
      end

      context 'when one of the user emails is in the TEST_USER_EMAILS list' do
        before { ENV['TEST_USER_EMAILS'] = user_2.email }

        it 'exludes that user from the result' do
          expect(result).to eq([procurement_7, procurement_6, procurement_4, procurement_3, procurement_1])
        end
      end
    end

    context 'when the data range includes some of the searches' do
      let(:start_date) { 5.days.ago - 1.hour }
      let(:end_date) { 1.day.ago + 1.hour }

      it 'returns only the searches in that date range' do
        expect(result).to eq([procurement_6, procurement_5, procurement_4, procurement_3, procurement_2])
      end

      context 'when one of the user emails is in the TEST_USER_EMAILS list' do
        before { ENV['TEST_USER_EMAILS'] = user_2.email }

        it 'exludes that user from the result' do
          expect(result).to eq([procurement_6, procurement_4, procurement_3])
        end
      end
    end
  end

  describe '.create_headers_row' do
    let(:result) { described_class.send(:create_headers_row) }

    it 'returns the expected headers' do
      expect(result).to eq(['User ID', 'Search date', 'Reference number', 'Contract name', 'Buyer organisation', 'Buyer organisation address', 'Buyer sector', 'Buyer contact name', 'Buyer contact job title', 'Buyer contact email address', 'Buyer contact telephone number', 'Buyer opted in to be contacted', 'Estimated annual cost', 'Estimated contract start date', 'Estimated contract duration', 'Requirements linked to PFI', 'Services', 'Regions', 'Lot', 'Suppliers'])
    end
  end

  # rubocop:disable RSpec/ExampleLength
  describe '.create_search_row' do
    let(:result) { described_class.send(:create_search_row, search) }

    context 'when the search is for lot 1a' do
      let(:search) { procurement_1 }

      it 'has the the expected cell values' do
        expect(result).to eq(
          [
            user_1.id,
            search.created_at.in_time_zone('London').strftime('%e %B %Y, %l:%M%P'),
            'RM6378-000001-2022',
            procurement_1.contract_name,
            'MyString',
            'MyString, MyString, MyString, MyString SW1W 9SZ',
            'Defence and Security',
            'MyString',
            'MyString',
            user_1.email,
            '07500404040',
            'Yes',
            '£12,345.00',
            ' 1 January 2028',
            '10 years',
            'Yes',
            "E1 Hard Landscaping Services\nE2 Soft Landscaping Services",
            "Essex (TLH3)\nNorfolk (TLH5)",
            'Lot 1a - Total Facilities Management',
            "CHARLES;\nMABEL;\nOLIVER"
          ]
        )
      end
    end

    context 'when the search is for lot 4b' do
      let(:search) { procurement_5 }

      it 'has the the expected cell values' do
        expect(result).to eq(
          [
            user_2.id,
            search.created_at.in_time_zone('London').strftime('%e %B %Y, %l:%M%P'),
            'RM6378-000001-2022',
            procurement_5.contract_name,
            'MyString',
            'MyString, MyString, MyString, MyString SW1W 9SZ',
            'Defence and Security',
            'MyString',
            'MyString',
            user_2.email,
            '07500404040',
            'Yes',
            '£19,176.00',
            '19 August 2035',
            '15 years',
            'No',
            "O4 Control of Access - Vehicles\nO7 Additional Security Officer Services",
            "Tees Valley (TLC3)\nCentral Valleys and Bridgend (TLL51)",
            'Lot 4b - Security Officer Services',
            "CHARLES;\nMABEL;\nOLIVER"
          ]
        )
      end
    end

    context 'when the search is for lot 3' do
      let(:search) { procurement_3 }

      it 'has the the expected cell values' do
        expect(result).to eq(
          [
            user_3.id,
            search.created_at.in_time_zone('London').strftime('%e %B %Y, %l:%M%P'),
            'RM6378-000001-2022',
            procurement_3.contract_name,
            'MyString',
            'MyString, MyString, MyString, MyString SW1W 9SZ',
            'Defence and Security',
            'MyString',
            'MyString',
            user_3.email,
            '07500404040',
            'No',
            '£93,874.00',
            '18 July 2028',
            '53 years',
            'No',
            "J3 General waste\nO8 Key Holding",
            "Outer London - South (TLI6)\nFlintshire and Wrexham (TLL34)",
            'Lot 3a - Soft Facilities Management',
            "CHARLES;\nMABEL;\nOLIVER"
          ]
        )
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
