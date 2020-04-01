require 'rails_helper'

RSpec.describe FacilitiesManagement::FurtherCompetitionSpreadsheetCreator do
  include ActionView::Helpers::NumberHelper

  let(:service_hours) { FacilitiesManagement::ServiceHours.new }

  let(:start_date) { DateTime.now.utc }
  let(:user_email) { 'test@example.com' }
  let(:user) { FactoryBot.create(:user, :without_detail, id: SecureRandom.uuid, email: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }

  # rubocop:disable Style/HashSyntax
  let(:data) do
    {
      :posted_locations => %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05],
      :posted_services => %w[J.8 H.16 C.21 H.9 E.1 C.15 C.10 E.9 C.11 H.12 M.1 I.3 C.14 J.2 L.1 F.1 K.1 G.8 G.13 G.5 G.2 K.5 H.7 E.5 E.6 J.3 H.3 D.6 G.4 F.3 L.3 E.7 J.4 J.9 F.4 K.7 C.4 E.8 L.4 L.5 L.8 F.5 H.10 K.2 D.1 L.7 H.4 K.4 N.1 C.13 F.6 G.10 L.10 C.7 H.2 G.11 L.6 J.10 C.5 G.16 J.11 C.20 C.17 H.1 J.6 J.1 C.1 G.14 K.6 G.3 H.5 C.18 F.7 J.5 J.12 G.15 C.9 E.4 H.15 H.6 D.3 L.9 G.9 J.7 C.8 I.1 K.3 H.13 D.4 F.10 F.2 G.1 C.6 H.8 H.11 G.12 C.22 L.2 C.12 E.3 H.14 I.2 C.16 L.11 D.2 F.8 F.9 C.2 C.19 I.4 E.2 G.7 G.6 C.3 D.5],
      :env => 'public-beta',
      :'fm-contract-length' => '7',
      :'fm-extension' => '',
      :'contract-extension-radio' => 'no',
      :'fm-contract-cost' => 0,
      :'is-tupe' => 'no',
      :'contract-extension' => 'no'
    }
  end

  let(:uvals) do
    [
      { :user_email => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'I.1', :uom_value => service_hours, :service_standard => 'A', :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_email => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'I.1', :uom_value => service_hours, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_email => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'K.3', :uom_value => 8, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_email => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :service_standard => 'A', :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_email => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_email => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'M.1', :uom_value => 1000, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'CAFM' },
      { :user_email => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'N.1', :uom_value => 1000, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'Help' }
    ]
  end

  before do
    service_hours[:monday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:tuesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:wednesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '08', start_minute: '00', start_ampm: 'am', end_hour: '05', end_minute: '30', end_ampm: 'PM', uom: 0)
    service_hours[:thursday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:friday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:saturday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'pm', end_hour: '05', end_minute: '30', end_ampm: 'AM', uom: 0)
    service_hours[:sunday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
  end

  # rubocop:disable RSpec/BeforeAfterAll
  context 'and add dummy buildings to a db', skip: true do
    before :all do
      @selected_buildings2 = [
        OpenStruct.new(
          id: 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b',
          user_email: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n',
          building_json: {
            'id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b',
            'gia' => 4200,
            'name' => 'c4',
            'region' => 'London',
            'description' => 'Channel 4',
            'address' => {
              'fm-address-town' => 'London',
              'fm-address-line-1' => '1 Horseferry Road',
              'fm-address-postcode' => 'SW1P 2BA',
              'fm-address-region' => 'Outer London - South'
            },
            'isLondon' => false,
            :'security-type' => 'Baseline Personnel Security Standard',
            'services' => [
              { 'code' => 'M-1', 'name' => 'CAFM system' },
              { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
              { 'code' => 'I-1', 'name' => 'Reception service' },
              { 'code' => 'K-3', 'name' => 'Recycled waste' }
            ],
            :'fm-building-type' => 'General office - Customer Facing',
            'building-type' => 'General office - Customer Facing'
          },
          status: 'Incomplete'
        ),
        OpenStruct.new(
          id: 'e60f5b57-5f15-604c-b729-a689ede34a99',
          user_email: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n',
          building_json: {
            'id' => 'e60f5b57-5f15-604c-b729-a689ede34a99',
            'gia' => 12000,
            'name' => 'ccs',
            'region' => 'London',
            'description' => 'Crown Commercial Service',
            'address' => {
              'fm-address-town' => 'London',
              'fm-address-line-1' => '151 Buckingham Palace Road',
              'fm-address-postcode' => 'SW1W 9SZ',
              'fm-address-region' => 'Outer London - South'
            },
            'isLondon' => false,
            :'security-type' => 'Baseline Personnel Security Standard',
            'services' => [
              { 'code' => 'M-1', 'name' => 'CAFM system' },
              { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
              { 'code' => 'I-1', 'name' => 'Reception service' },
              { 'code' => 'K-3', 'name' => 'Recycled waste' }
            ],
            :'fm-building-type' => 'Warehouse',
            'building-type' => 'Warehouse'
          },
          status: 'Incomplete'
        )
      ]

      # populate db with dub buildings
      # rubocop:disable RSpec/InstanceVariable
      @selected_buildings2.each do |b|
        FacilitiesManagement::Building.delete b.id
        new_building = FacilitiesManagement::Building.new(
          id: b.id,
          user: create(:user),
          user_email: Base64.encode64('test@example.com'),
          updated_by: Base64.encode64('test@example.com'),
          building_json: b.building_json
        )

        new_building.save
        new_building.reload
      rescue StandardError => e
        Rails.logger.warn "Couldn't update new building id: #{e}"
      end
    end
    # rubocop:enable Style/HashSyntax

    after :all do
      # teardown
      @selected_buildings2.each do |b|
        FacilitiesManagement::Building.delete b.id
      rescue StandardError => e
        Rails.logger.warn "Couldn't delete new building id: #{e}"
      end
    end
    # rubocop:enable RSpec/BeforeAfterAll
    # rubocop:enable RSpec/InstanceVariable

    # rubocop:disable RSpec/ExampleLength
    it 'verify address formatting' do
      buildings_ids = uvals.collect { |u| u[:building_id] }.compact.uniq

      building_ids_with_service_codes2 = buildings_ids.collect do |b|
        services_per_building = uvals.select { |u| u[:building_id] == b }.collect { |u| u[:service_code] }
        { building_id: b.downcase, service_codes: services_per_building }
      end

      spreadsheet_builder = described_class.new(building_ids_with_service_codes2)

      buyer_detail = OpenStruct.new(
        organisation_address_line_1: 'ab',
        organisation_address_line_2: 'cd',
        organisation_address_town: 'london',
        organisation_address_county: 'kk',
        organisation_address_postcode: 'sw14567'
      )

      expect(spreadsheet_builder.get_address(buyer_detail)).to eq('ab, cd, london, kk. sw14567')
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength
    it 'verify worksheets are present' do
      buildings_ids = uvals.collect { |u| u[:building_id] }.compact.uniq

      building_ids_with_service_codes2 = buildings_ids.collect do |b|
        services_per_building = uvals.select { |u| u[:building_id] == b }.collect { |u| u[:service_code] }
        { building_id: b.downcase, service_codes: services_per_building }
      end

      spreadsheet_builder = described_class.new(building_ids_with_service_codes2, uvals)
      spreadsheet_builder.session_data = data
      spreadsheet = spreadsheet_builder.build(start_date, user)

      IO.write('/tmp/further_competition_procurement_summary.xlsx', spreadsheet.to_stream.read)

      wb = Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')
      rows_found = true
      rows_found = false if wb.sheet('Service Matrix').last_row == 0
      rows_found = false if wb.sheet('Volume').last_row == 0
      rows_found = false if wb.sheet('Service Periods').last_row == 0
      rows_found = false if wb.sheet('Shortlist').last_row == 0
      expect(rows_found).to be true
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength
    it 'verify service matrix worksheet' do
      buildings_ids = uvals.collect { |u| u[:building_id] }.compact.uniq

      building_ids_with_service_codes2 = buildings_ids.collect do |b|
        services_per_building = uvals.select { |u| u[:building_id] == b }.collect { |u| u[:service_code] }
        { building_id: b.downcase, service_codes: services_per_building }
      end

      spreadsheet_builder = described_class.new(building_ids_with_service_codes2, uvals)
      spreadsheet_builder.session_data = data
      spreadsheet = spreadsheet_builder.build(start_date, user)

      IO.write('/tmp/further_competition_procurement_summary.xlsx', spreadsheet.to_stream.read)

      wb = Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')
      expect(wb.sheet('Service Matrix').row(2)).to eq ['C.5', 'Lifts, hoists & conveyance systems maintenance - Standard A', 'Yes', 'Yes']
      expect(wb.sheet('Service Matrix').row(4)).to eq ['K.3', 'Recycled waste', nil, 'Yes']
      expect(wb.sheet('Service Matrix').row(5)).to eq ['M.1', 'CAFM system', nil, 'Yes']
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
