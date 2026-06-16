require 'rails_helper'

RSpec.describe ChangeLog::CsvGenerator, type: :helper do
  before do
    view.extend(ApplicationHelper)
    view.extend(Admin::ChangeLogsHelper)
  end

  describe '.generate_csv' do
    let(:framework) { Framework.find('RM6376') }
    let(:user_1) { create(:user, email: 'reiner.braun@attackontitn.pa') }
    let(:user_2) { create(:user, email: 'bertholdt.hoover@attackontitn.pa') }
    let(:generated_csv) { CSV.parse(described_class.new(framework.id, view).generate_csv) }

    def get_time(n_of_days)
      Time.zone.local(2026, 6, 9, 16, 0).in_time_zone('London') - n_of_days.days
    end

    before do
      create(
        :change_log,
        :with_upload_supplier_data_change_type,
        framework: framework,
        user: user_1,
        created_at: get_time(7),
        id: 'e383e739-769e-4ad3-b5ba-3d70b0a8f0df',
        change_data: { 'admin_upload_id' => 'b62a68bd-9642-4aa2-8a96-8e4aeaf8724d', 'supplier_data' => {} }
      )
      create(
        :change_log,
        :with_update_supplier_information_change_type,
        framework: framework,
        user: user_2,
        created_at: get_time(8),
        id: '7ac1cb41-bf3f-41d6-9ee4-8c25c2082300',
        change_data: { 'id' => 'abc9119f-baf9-4ad2-9dd3-0151993a18ef', 'supplier_name' => 'Eren Jaeger', 'before' => { 'name' => 'Unknown Rogue Titan' }, 'after' => { 'name' => 'The Attack Titan' } }
      )
      create(
        :change_log,
        :with_update_supplier_contact_information_change_type,
        framework: framework,
        user: user_1,
        created_at: get_time(9),
        id: '009aae1a-4a8d-42d6-82e4-43a068bcfc60',
        change_data: {
          'id' => 'f70487e9-f873-42bf-98ec-9c5941ae0ece',
          'supplier_name' => 'Captain Levi Ackerman',
          'before' => {
            'name' => 'Erwin Smith',
            'email' => 'commander.erwin@scoutregiment.paradis',
            'telephone_number' => 'WALL-ROSE-001',
            'website' => 'http://scouts.paradis/hq'
          },
          'after' => {
            'name' => 'Levi Ackerman',
            'email' => 'humanitys.strongest@scoutregiment.paradis',
            'telephone_number' => 'FIELD-COMM-Vanguard',
            'website' => 'http://scouts.paradis/special-ops'
          }
        }
      )
      create(
        :change_log,
        :with_update_supplier_additional_information_change_type,
        framework: framework,
        user: user_2,
        created_at: get_time(10),
        id: '25c37e2e-1955-40f4-94d4-334d86bdb49a',
        change_data: {
          'id' => '24d9adb7-a45c-46de-b5e0-a95430c6566f',
          'supplier_name' => 'Hange Zoë Research Lab',
          'before' => {
            'additional_details' => {
              'managed_service_provider_name' => 'Standard Garrison Blacksmiths',
              'managed_service_provider_email' => 'blades@garrison.paradis',
              'managed_service_provider_telephone' => '001-OLD-STEEL'
            }
          },
          'after' => {
            'additional_details' => {
              'managed_service_provider_name' => 'Anti-Personnel ODM Engineers',
              'managed_service_provider_email' => 'thunder-spears@hange-labs.paradis',
              'managed_service_provider_telephone' => '888-BOOM-GEAR'
            }
          }
        }
      )
      create(
        :change_log,
        :with_update_supplier_framework_lot_status_change_type,
        framework: framework,
        user: user_1,
        created_at: get_time(11),
        id: 'f6cb2ed2-3b4c-4000-84c6-cedbf53558b8',
        change_data: {
          'id' => '4151a90a-2274-484d-9d14-8af6673e9b5a',
          'supplier_name' => 'Garrison Regiment Guard',
          'lot_id' => 'RM6360.1',
          'before' => { 'enabled' => true },
          'after' => { 'enabled' => false }
        }
      )
      create(
        :change_log,
        :with_update_supplier_framework_lot_services_change_type,
        framework: framework,
        user: user_2,
        created_at: get_time(1),
        id: '1ec6f9f2-9757-4eb6-8a81-794cc6fd048a',
        change_data: {
          'id' => '0a35a011-8f42-49b8-8738-2eefa9a209fb',
          'supplier_name' => '104th Training Corps',
          'lot_id' => 'RM6360.1',
          'added' => ['RM6360.1.1', 'RM6360.1.2', 'RM6360.1.3'],
          'removed' => ['RM6360.1.4', 'RM6360.1.5', 'RM6360.1.6']
        }
      )
      create(
        :change_log,
        :with_update_supplier_framework_lot_jurisdictions_change_type,
        framework: framework,
        user: user_2,
        created_at: get_time(2),
        id: '7d623ebf-e8d6-4a33-8964-5acb8e5c8ebc',
        change_data: {
          'id' => 'b5fffe0e-cd1a-42d9-b935-c080c476e27c',
          'supplier_name' => 'Armin Arlert',
          'lot_id' => 'RM6360.1',
          'added' => ['RM6360.BR', 'RM6360.CN', 'RM6360.JP'],
          'removed' => ['RM6360.HK', 'RM6360.KH', 'RM6360.ME']
        }
      )
      create(
        :change_log,
        :with_update_supplier_framework_lot_rates_change_type,
        framework: framework,
        user: user_1,
        created_at: get_time(3),
        id: 'e3b45349-3763-4029-a0d7-8982ff56b7cd',
        'change_data' => {
          'id' => '7331826c-8f3c-4a95-aa25-a95a31e5a1cd',
          'supplier_name' => 'Reeves Commerce Guild',
          'lot_id' => 'RM6376.1',
          'jurisdiction_id' => 'RM6376.GB',
          'rates' => [
            { 'after' => 15000, 'id' => '53fd6a82-4a7b-4b22-86bc-d1ea53bec6b1', 'position_id' => 'RM6376.1.1' },
            { 'after' => 18000, 'id' => '9ea462c8-d79f-4c1c-b775-579cdc136317', 'position_id' => 'RM6376.1.2' },
            { 'after' => 20000, 'id' => 'd326cb6e-456d-460b-bd7d-bc836c37a38a', 'position_id' => 'RM6376.1.3' }
          ]
        }
      )
      create(
        :change_log,
        :with_add_rates_for_supplier_framework_lot_jurisdiction_change_type,
        framework: framework,
        user: user_2,
        created_at: get_time(4),
        id: '6918b70d-fc43-4b8f-ae6a-025288863257',
        change_data: {
          'id' => '7331826c-8f3c-4a95-aa25-a95a31e5a1cd',
          'supplier_name' => 'Mikasa Ackerman',
          'lot_id' => 'RM6376.1',
          'jurisdiction_id' => 'RM6376.GB',
          'rates' => [
            { 'after' => 15000, 'id' => '53fd6a82-4a7b-4b22-86bc-d1ea53bec6b1', 'position_id' => 'RM6376.1.1' },
            { 'after' => 18000, 'id' => '9ea462c8-d79f-4c1c-b775-579cdc136317', 'position_id' => 'RM6376.1.2' },
            { 'after' => 20000, 'id' => 'd326cb6e-456d-460b-bd7d-bc836c37a38a', 'position_id' => 'RM6376.1.3' }
          ]
        }
      )
      create(
        :change_log,
        :with_remove_rates_for_supplier_framework_lot_jurisdiction_change_type,
        framework: framework,
        user: user_1,
        created_at: get_time(5),
        id: 'f578f552-c057-46f3-8cd8-47eb02953140',
        change_data: {
          'id' => '48988a3d-07f2-41c7-b42a-79e6ae820e31',
          'supplier_name' => 'Reiner Braun',
          'lot_id' => 'RM6376.1',
          'jurisdiction_id' => 'RM6376.GB',
          'rates' => [
            { 'before' => 15000, 'id' => '1a7599cf-da42-480f-b4a9-69a4401e12ca', 'position_id' => 'RM6376.1.1' },
            { 'before' => 18000, 'id' => 'b64d455a-b8e9-4a17-816e-27d1facdf28a', 'position_id' => 'RM6376.1.2' },
            { 'before' => 20000, 'id' => '74fc0cea-a3c9-4fbc-b037-8f8212eb53a6', 'position_id' => 'RM6376.1.3' }
          ]
        }
      )
      create(
        :change_log,
        :with_update_supplier_framework_lot_branch_change_type,
        framework: framework,
        user: user_2,
        created_at: get_time(6),
        id: 'd7a64810-0769-4d44-afe9-2b6128ff30a7',
        change_data: {
          'id' => '6606950d-b51d-4038-8199-57d9617b0779',
          'supplier_name' => 'Scout Regiment Command Base',
          'lot_id' => 'RM6376.1',
          'before' => { 'address_line_1' => 'Shiganshina Headquarters Castle' },
          'after' => { 'address_line_2' => 'Abandoned Forest Log Cabin Hideout' }
        }
      )
    end

    it 'has the right headers' do
      expect(generated_csv.first).to eq(['Log item', 'Change type', 'Changed by', 'Changed at', 'Supplier name', 'Lot', 'Jurisdiction', 'Attribute', 'Poisiton', 'Type', 'Old value/Removed', 'New value/Added'])
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'has the correct data in rows for upload_supplier_data' do
      expect(generated_csv[14]).to eq(['#e383e739', 'Upload', 'reiner.braun@attackontitn.pa', '2 June 2026, 5:00pm', nil, nil, nil, nil, nil, nil, nil, 'http://localhost/supply-teachers/RM6376/admin/uploads/b62a68bd-9642-4aa2-8a96-8e4aeaf8724d'])
    end

    it 'has the correct data in rows for update_supplier_information' do
      expect(generated_csv[15]).to eq(['#7ac1cb41', 'Supplier information update', 'bertholdt.hoover@attackontitn.pa', '1 June 2026, 5:00pm', 'Eren Jaeger', nil, nil, 'Name', nil, nil, 'Unknown Rogue Titan', 'The Attack Titan'])
    end

    it 'has the correct data in rows for update_supplier_contact_information' do
      expect(generated_csv[16]).to eq(['#009aae1a', 'Supplier contact information update', 'reiner.braun@attackontitn.pa', '31 May 2026, 5:00pm', 'Captain Levi Ackerman', nil, nil, 'Contact name', nil, nil, 'Erwin Smith', 'Levi Ackerman'])
      expect(generated_csv[17]).to eq(['#009aae1a', 'Supplier contact information update', 'reiner.braun@attackontitn.pa', '31 May 2026, 5:00pm', 'Captain Levi Ackerman', nil, nil, 'Contact email', nil, nil, 'commander.erwin@scoutregiment.paradis', 'humanitys.strongest@scoutregiment.paradis'])
      expect(generated_csv[18]).to eq(['#009aae1a', 'Supplier contact information update', 'reiner.braun@attackontitn.pa', '31 May 2026, 5:00pm', 'Captain Levi Ackerman', nil, nil, 'Contact telephone number', nil, nil, 'WALL-ROSE-001', 'FIELD-COMM-Vanguard'])
      expect(generated_csv[19]).to eq(['#009aae1a', 'Supplier contact information update', 'reiner.braun@attackontitn.pa', '31 May 2026, 5:00pm', 'Captain Levi Ackerman', nil, nil, 'Website', nil, nil, 'http://scouts.paradis/hq', 'http://scouts.paradis/special-ops'])
    end

    it 'has the correct data in rows for update_supplier_additional_information' do
      expect(generated_csv[20]).to eq(['#25c37e2e', 'Additional supplier information update', 'bertholdt.hoover@attackontitn.pa', '30 May 2026, 5:00pm', 'Hange Zoë Research Lab', nil, nil, 'Managed service provider contact name', nil, nil, 'Standard Garrison Blacksmiths', 'Anti-Personnel ODM Engineers'])
      expect(generated_csv[21]).to eq(['#25c37e2e', 'Additional supplier information update', 'bertholdt.hoover@attackontitn.pa', '30 May 2026, 5:00pm', 'Hange Zoë Research Lab', nil, nil, 'Managed service provider contact email', nil, nil, 'blades@garrison.paradis', 'thunder-spears@hange-labs.paradis'])
      expect(generated_csv[22]).to eq(['#25c37e2e', 'Additional supplier information update', 'bertholdt.hoover@attackontitn.pa', '30 May 2026, 5:00pm', 'Hange Zoë Research Lab', nil, nil, 'Managed service provider contact telephone number', nil, nil, '001-OLD-STEEL', '888-BOOM-GEAR'])
    end

    it 'has the correct data in rows for update_supplier_framework_lot_status' do
      expect(generated_csv[23]).to eq(['#f6cb2ed2', 'Lot status update', 'reiner.braun@attackontitn.pa', '29 May 2026, 5:00pm', 'Garrison Regiment Guard', 'Lot 1 - Core Legal Services', nil, 'Lot status update', nil, nil, 'Enabled', 'Disabled'])
    end

    it 'has the correct data in rows for update_supplier_framework_lot_services' do
      expect(generated_csv[1]).to eq(['#1ec6f9f2', 'Services update', 'bertholdt.hoover@attackontitn.pa', '8 June 2026, 5:00pm', '104th Training Corps', 'Lot 1 - Core Legal Services', nil, 'Services', nil, nil, "Children and Vulnerable Adults;\nCommercial Litigation and Dispute Resolution;\nCompetition Law;", "Assimilated Law;\nAviation and Airports;\nCharities;"])
    end

    it 'has the correct data in rows for update_supplier_framework_lot_jurisdictions' do
      expect(generated_csv[2]).to eq(['#7d623ebf', 'Jurisdictions update', 'bertholdt.hoover@attackontitn.pa', '7 June 2026, 5:00pm', 'Armin Arlert', 'Lot 1 - Core Legal Services', nil, 'Jurisdictions', nil, nil, "non-core:\nCambodia;\nHong Kong;\nMontenegro;", "non-core:\nBrazil;\nChina;\nJapan;"])
    end

    it 'has the correct data in rows for update_supplier_framework_lot_rates' do
      expect(generated_csv[3]).to eq(['#e3b45349', 'Rates update', 'reiner.braun@attackontitn.pa', '6 June 2026, 5:00pm', 'Reeves Commerce Guild', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'STEM Teacher (Inc. Qualified Teachers, Tutors)', 'Agency mark-up', nil, '£150.00'])
      expect(generated_csv[4]).to eq(['#e3b45349', 'Rates update', 'reiner.braun@attackontitn.pa', '6 June 2026, 5:00pm', 'Reeves Commerce Guild', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'Non-STEM Teachers (Inc. Qualified Teachers, Tutors)', 'Agency mark-up', nil, '£180.00'])
      expect(generated_csv[5]).to eq(['#e3b45349', 'Rates update', 'reiner.braun@attackontitn.pa', '6 June 2026, 5:00pm', 'Reeves Commerce Guild', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'Educational Support Staff non SEND (Inc. Cover Supervisor, Teaching Assistants and unqualified teachers)', 'Agency mark-up', nil, '£200.00'])
    end

    it 'has the correct data in rows for add_rates_for_supplier_framework_lot_jurisdiction' do
      expect(generated_csv[6]).to eq(['#6918b70d', 'Add rates for jurisdiction', 'bertholdt.hoover@attackontitn.pa', '5 June 2026, 5:00pm', 'Mikasa Ackerman', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'STEM Teacher (Inc. Qualified Teachers, Tutors)', 'Agency mark-up', nil, '£150.00'])
      expect(generated_csv[7]).to eq(['#6918b70d', 'Add rates for jurisdiction', 'bertholdt.hoover@attackontitn.pa', '5 June 2026, 5:00pm', 'Mikasa Ackerman', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'Non-STEM Teachers (Inc. Qualified Teachers, Tutors)', 'Agency mark-up', nil, '£180.00'])
      expect(generated_csv[8]).to eq(['#6918b70d', 'Add rates for jurisdiction', 'bertholdt.hoover@attackontitn.pa', '5 June 2026, 5:00pm', 'Mikasa Ackerman', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'Educational Support Staff non SEND (Inc. Cover Supervisor, Teaching Assistants and unqualified teachers)', 'Agency mark-up', nil, '£200.00'])
    end

    it 'has the correct data in rows for remove_rates_for_supplier_framework_lot_jurisdiction' do
      expect(generated_csv[9]).to eq(['#f578f552', 'Remove rates for jurisdiction', 'reiner.braun@attackontitn.pa', '4 June 2026, 5:00pm', 'Reiner Braun', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'STEM Teacher (Inc. Qualified Teachers, Tutors)', 'Agency mark-up', '£150.00', nil])
      expect(generated_csv[10]).to eq(['#f578f552', 'Remove rates for jurisdiction', 'reiner.braun@attackontitn.pa', '4 June 2026, 5:00pm', 'Reiner Braun', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'Non-STEM Teachers (Inc. Qualified Teachers, Tutors)', 'Agency mark-up', '£180.00', nil])
      expect(generated_csv[11]).to eq(['#f578f552', 'Remove rates for jurisdiction', 'reiner.braun@attackontitn.pa', '4 June 2026, 5:00pm', 'Reiner Braun', 'Lot 1 - Direct provision', 'United Kingdom', 'Rate', 'Educational Support Staff non SEND (Inc. Cover Supervisor, Teaching Assistants and unqualified teachers)', 'Agency mark-up', '£200.00', nil])
    end

    it 'has the correct data in rows for update_supplier_framework_lot_branch' do
      expect(generated_csv[12]).to eq(['#d7a64810', 'Branch update', 'bertholdt.hoover@attackontitn.pa', '3 June 2026, 5:00pm', 'Scout Regiment Command Base', 'Lot 1 - Direct provision', nil, 'Address line 1', nil, nil, 'Shiganshina Headquarters Castle', nil])
      expect(generated_csv[13]).to eq(['#d7a64810', 'Branch update', 'bertholdt.hoover@attackontitn.pa', '3 June 2026, 5:00pm', 'Scout Regiment Command Base', 'Lot 1 - Direct provision', nil, 'Address line 2', nil, nil, nil, 'Abandoned Forest Log Cabin Hideout'])
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
