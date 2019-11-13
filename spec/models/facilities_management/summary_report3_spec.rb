require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  # rubocop:disable Style/HashSyntax
  let(:data) do
    {
      :posted_locations => ['UKC1', 'UKC2', 'UKD1', 'UKD3', 'UKD4', 'UKD6', 'UKD7', 'UKE1', 'UKE2', 'UKE3', 'UKE4', 'UKF1', 'UKF2', 'UKF3', 'UKG1', 'UKG2', 'UKG3', 'UKH1', 'UKH2', 'UKH3', 'UKI3', 'UKI4', 'UKI5', 'UKI6', 'UKI7', 'UKJ1', 'UKJ2', 'UKJ3', 'UKJ4', 'UKK1', 'UKK2', 'UKK3', 'UKK4', 'UKL11', 'UKL12', 'UKL13', 'UKL14', 'UKL15', 'UKL16', 'UKL17', 'UKL18', 'UKL21', 'UKL22', 'UKL23', 'UKL24', 'UKM21', 'UKM22', 'UKM23', 'UKM24', 'UKM25', 'UKM26', 'UKM27', 'UKM28', 'UKM31', 'UKM32', 'UKM33', 'UKM34', 'UKM35', 'UKM36', 'UKM37', 'UKM38', 'UKM50', 'UKM61', 'UKM62', 'UKM63', 'UKM64', 'UKM65', 'UKM66', 'UKN01', 'UKN02', 'UKN03', 'UKN04', 'UKN05'],
      :posted_services => ['J.8', 'H.16', 'C.21', 'H.9', 'E.1', 'C.15', 'C.10', 'E.9', 'C.11', 'H.12', 'M.1', 'I.3', 'C.14', 'J.2', 'L.1', 'F.1', 'K.1', 'G.8', 'G.13', 'G.5', 'G.2', 'K.5', 'H.7', 'E.5', 'E.6', 'J.3', 'H.3', 'D.6', 'G.4', 'F.3', 'L.3', 'E.7', 'J.4', 'J.9', 'F.4', 'K.7', 'C.4', 'E.8', 'L.4', 'L.5', 'L.8', 'F.5', 'H.10', 'K.2', 'D.1', 'L.7', 'H.4', 'K.4', 'N.1', 'C.13', 'F.6', 'G.10', 'L.10', 'C.7', 'H.2', 'G.11', 'L.6', 'J.10', 'C.5', 'G.16', 'J.11', 'C.20', 'C.17', 'H.1', 'J.6', 'J.1', 'C.1', 'G.14', 'K.6', 'G.3', 'H.5', 'C.18', 'F.7', 'J.5', 'J.12', 'G.15', 'C.9', 'E.4', 'H.15', 'H.6', 'D.3', 'L.9', 'G.9', 'J.7', 'C.8', 'I.1', 'K.3', 'H.13', 'D.4', 'F.10', 'F.2', 'G.1', 'C.6', 'H.8', 'H.11', 'G.12', 'C.22', 'L.2', 'C.12', 'E.3', 'H.14', 'I.2', 'C.16', 'L.11', 'D.2', 'F.8', 'F.9', 'C.2', 'C.19', 'I.4', 'E.2', 'G.7', 'G.6', 'C.3', 'D.5'],
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
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'E.4', 'uom_value' => '1', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.1', 'uom_value' => '2', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.3', 'uom_value' => '3', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.5', 'uom_value' => '4', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.4', 'uom_value' => '5', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.5', 'uom_value' => '6', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.1', 'uom_value' => '7', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.2', 'uom_value' => '8', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.3', 'uom_value' => '9', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.4', 'uom_value' => '10', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.1', 'uom_value' => '11', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.2', 'uom_value' => '12', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.3', 'uom_value' => '13', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.4', 'uom_value' => '14', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.5', 'uom_value' => '15', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.6', 'uom_value' => '16', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.1', 'uom_value' => '17', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.2', 'uom_value' => '18', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.3', 'uom_value' => '19', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.7', 'uom_value' => '20', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'E.4', 'uom_value' => '30', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.1', 'uom_value' => '31', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.3', 'uom_value' => '32', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.5', 'uom_value' => '33', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.4', 'uom_value' => '34', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.5', 'uom_value' => '35', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.1', 'uom_value' => '36', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.2', 'uom_value' => '37', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.3', 'uom_value' => '38', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.4', 'uom_value' => '39', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.1', 'uom_value' => '40', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.2', 'uom_value' => '41', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.3', 'uom_value' => '42', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.4', 'uom_value' => '43', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.5', 'uom_value' => '44', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.6', 'uom_value' => '45', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.1', 'uom_value' => '46', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.2', 'uom_value' => '47', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.3', 'uom_value' => '48', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.7', 'uom_value' => '49', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 4, :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 6, :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' }
    ]
  end

  # rubocop:disable Layout/AlignArray
  # rubocop:disable Layout/MultilineHashBraceLayout
  # rubocop:disable RSpec/BeforeAfterAll
  context 'and dummy buildings to a db' do
    before :all do
      @selected_buildings2 = [
        OpenStruct.new(
          id: 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b',
          user_id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n',
          building_json: {
            'id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b',
            'gia' => 4200,
            'name' => 'c4',
            'region' => 'London',
            'description' => 'Channel 4',
            'address' => { 'fm-address-town' => 'London', 'fm-address-line-1' => '1 Horseferry Road', 'fm-address-postcode' => 'SW1P 2BA' },
            'isLondon' => 'No',
            :'security-type' => 'Baseline Personnel Security Standard',
            'services' => [
              { 'code' => 'J-8', 'name' => 'Additional security services' },
              { 'code' => 'H-16', 'name' => 'Administrative support services' },
              { 'code' => 'C-21', 'name' => 'Airport and aerodrome maintenance services' },
              { 'code' => 'H-9', 'name' => 'Archiving (on-site)' },
              { 'code' => 'E-1', 'name' => 'Asbestos management' },
              { 'code' => 'C-15', 'name' => 'Audio visual (AV) equipment maintenance' },
              { 'code' => 'C-10', 'name' => 'Automated barrier control system maintenance' },
              { 'code' => 'E-9', 'name' => 'Building information modelling and government soft landings' },
              { 'code' => 'C-11', 'name' => 'Building management system (BMS) maintenance' },
              { 'code' => 'H-12', 'name' => 'Cable management' },
              { 'code' => 'M-1', 'name' => 'CAFM system' },
              { 'code' => 'I-3', 'name' => 'Car park management and booking' },
              { 'code' => 'C-14', 'name' => 'Catering equipment maintenance' },
              { 'code' => 'J-2', 'name' => 'CCTV / alarm monitoring' },
              { 'code' => 'L-1', 'name' => 'Childcare facility' },
              { 'code' => 'F-1', 'name' => 'Chilled potable water' },
              { 'code' => 'K-1', 'name' => 'Classified waste' },
              { 'code' => 'G-8', 'name' => 'Cleaning of communications and equipment rooms' },
              { 'code' => 'G-13', 'name' => 'Cleaning of curtains and window blinds' },
              { 'code' => 'G-5', 'name' => 'Cleaning of external areas' },
              { 'code' => 'G-2', 'name' => 'Cleaning of integral barrier mats' },
              { 'code' => 'K-5', 'name' => 'Clinical waste' },
              { 'code' => 'H-7', 'name' => 'Clocks' },
              { 'code' => 'E-5', 'name' => 'Compliance plans, specialist surveys and audits' },
              { 'code' => 'E-6', 'name' => 'Conditions survey' },
              { 'code' => 'J-3', 'name' => 'Control of access and security passes' },
              { 'code' => 'H-3', 'name' => 'Courier booking and external distribution' },
              { 'code' => 'D-6', 'name' => 'Cut flowers and christmas trees' },
              { 'code' => 'G-4', 'name' => 'Deep (periodic) cleaning' },
              { 'code' => 'F-3', 'name' => 'Deli/coffee bar' },
              { 'code' => 'L-3', 'name' => 'Driver and vehicle service' },
              { 'code' => 'E-7', 'name' => 'Electrical testing' },
              { 'code' => 'J-4', 'name' => 'Emergency response' },
              { 'code' => 'J-9', 'name' => 'Enhanced security requirements' },
              { 'code' => 'C-3', 'name' => 'Environmental cleaning service' },
              { 'code' => 'F-4', 'name' => 'Events and functions' },
              { 'code' => 'K-7', 'name' => 'Feminine hygiene waste' },
              { 'code' => 'C-4', 'name' => 'Fire detection and firefighting systems maintenance' },
              { 'code' => 'E-8', 'name' => 'Fire risk assessments' },
              { 'code' => 'L-4', 'name' => 'First aid and medical service' },
              { 'code' => 'L-5', 'name' => 'Flag flying service' },
              { 'code' => 'L-8', 'name' => 'Footwear cobbling services' },
              { 'code' => 'F-5', 'name' => 'Full service restaurant' },
              { 'code' => 'H-10', 'name' => 'Furniture management' },
              { 'code' => 'K-2', 'name' => 'General waste' },
              { 'code' => 'D-1', 'name' => 'Grounds maintenance services' },
              { 'code' => 'L-7', 'name' => 'Hairdressing services' },
              { 'code' => 'H-4', 'name' => 'Handyman services' },
              { 'code' => 'K-4', 'name' => 'Hazardous waste' },
              { 'code' => 'N-1', 'name' => 'Helpdesk services' },
              { 'code' => 'C-13', 'name' => 'High voltage (HV) and switchgear maintenance' },
              { 'code' => 'F-6', 'name' => 'Hospitality and meetings' },
              { 'code' => 'G-10', 'name' => 'Housekeeping' },
              { 'code' => 'L-10', 'name' => 'Housing and residential accommodation management' },
              { 'code' => 'C-7', 'name' => 'Internal and external building fabric maintenance' },
              { 'code' => 'H-2', 'name' => 'Internal messenger service' },
              { 'code' => 'D-5', 'name' => 'Internal planting' },
              { 'code' => 'G-11', 'name' => 'It equipment cleaning' },
              { 'code' => 'L-6', 'name' => 'Journal, magazine and newspaper supply' },
              { 'code' => 'J-10', 'name' => 'Key holding' },
              { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
              { 'code' => 'G-16', 'name' => 'Linen and laundry services' },
              { 'code' => 'J-11', 'name' => 'Lock up / open up of buyer premises' },
              { 'code' => 'C-20', 'name' => 'Locksmith services' },
              { 'code' => 'C-17', 'name' => 'Mail room equipment maintenance' },
              { 'code' => 'H-1', 'name' => 'Mail services' },
              { 'code' => 'J-6', 'name' => 'Management of visitors and passes' },
              { 'code' => 'J-1', 'name' => 'Manned guarding service' },
              { 'code' => 'C-1', 'name' => 'Mechanical and electrical engineering maintenance' },
              { 'code' => 'G-14', 'name' => 'Medical and clinical cleaning' },
              { 'code' => 'K-6', 'name' => 'Medical waste' },
              { 'code' => 'G-3', 'name' => 'Mobile cleaning services' },
              { 'code' => 'H-5', 'name' => 'Move and space management - internal moves' },
              { 'code' => 'C-18', 'name' => 'Office machinery servicing and maintenance' },
              { 'code' => 'F-7', 'name' => 'Outside catering' },
              { 'code' => 'J-5', 'name' => 'Patrols (fixed or static guarding)' },
              { 'code' => 'J-12', 'name' => 'Patrols (mobile via a specific visiting vehicle)' },
              { 'code' => 'G-15', 'name' => 'Pest control services' },
              { 'code' => 'C-9', 'name' => 'Planned / group re-lamping service' },
              { 'code' => 'E-4', 'name' => 'Portable appliance testing' },
              { 'code' => 'H-15', 'name' => 'Portable washroom solutions' },
              { 'code' => 'H-6', 'name' => 'Porterage' },
              { 'code' => 'D-3', 'name' => 'Professional snow & ice clearance' },
              { 'code' => 'L-9', 'name' => 'Provision of chaplaincy support services' },
              { 'code' => 'G-9', 'name' => 'Reactive cleaning (outside cleaning operational hours)' },
              { 'code' => 'J-7', 'name' => 'Reactive guarding' },
              { 'code' => 'C-8', 'name' => 'Reactive maintenance services' },
              { 'code' => 'I-1', 'name' => 'Reception service' },
              { 'code' => 'K-3', 'name' => 'Recycled waste' },
              { 'code' => 'H-13', 'name' => 'Reprographics service' },
              { 'code' => 'D-4', 'name' => 'Reservoirs, ponds, river walls and water features maintenance' },
              { 'code' => 'F-10', 'name' => 'Residential catering services' },
              { 'code' => 'F-2', 'name' => 'Retail services / convenience store' },
              { 'code' => 'G-1', 'name' => 'Routine cleaning' },
              { 'code' => 'C-6', 'name' => 'Security, access and intruder systems maintenance' },
              { 'code' => 'H-8', 'name' => 'Signage' },
              { 'code' => 'H-11', 'name' => 'Space management' },
              { 'code' => 'G-12', 'name' => 'Specialist cleaning' },
              { 'code' => 'C-22', 'name' => 'Specialist maintenance services' },
              { 'code' => 'L-2', 'name' => 'Sports and leisure' },
              { 'code' => 'C-12', 'name' => 'Standby power system maintenance' },
              { 'code' => 'E-3', 'name' => 'Statutory inspections' },
              { 'code' => 'H-14', 'name' => 'Stores management' },
              { 'code' => 'I-2', 'name' => 'Taxi booking service' },
              { 'code' => 'C-16', 'name' => 'Television cabling maintenance' },
              { 'code' => 'L-11', 'name' => 'Training establishment management and booking service' },
              { 'code' => 'D-2', 'name' => 'Tree surgery (arboriculture)' },
              { 'code' => 'F-8', 'name' => 'Trolley service' },
              { 'code' => 'F-9', 'name' => 'Vending services (food & beverage)' },
              { 'code' => 'C-2', 'name' => 'Ventilation and air conditioning system maintenance' },
              { 'code' => 'C-19', 'name' => 'Voice announcement system maintenance' },
              { 'code' => 'I-4', 'name' => 'Voice announcement system operation' },
              { 'code' => 'E-2', 'name' => 'Water hygiene maintenance' },
              { 'code' => 'G-7', 'name' => 'Window cleaning (external)' },
              { 'code' => 'G-6', 'name' => 'Window cleaning (internal)' }
            ],
            :'fm-building-type' => 'General office - Customer Facing' },
          status: 'Incomplete'
        ),

        OpenStruct.new(
          id: 'e60f5b57-5f15-604c-b729-a689ede34a99',
          user_id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n',
          building_json: {
            'id' => 'e60f5b57-5f15-604c-b729-a689ede34a99',
            'gia' => 12000,
            'name' => 'ccs',
            'region' => 'London',
            'description' => 'Crown Commercial Service',
            'address' => {
              'fm-address-town' => 'London',
              'fm-address-line-1' => '151 Buckingham Palace Road',
              'fm-address-postcode' => 'SW1W 9SZ'
            },
            'isLondon' => 'No',
            :'security-type' => 'Baseline Personnel Security Standard',
            'services' => [
              { 'code' => 'J-8', 'name' => 'Additional security services' },
              { 'code' => 'H-16', 'name' => 'Administrative support services' },
              { 'code' => 'C-21', 'name' => 'Airport and aerodrome maintenance services' },
              { 'code' => 'H-9', 'name' => 'Archiving (on-site)' },
              { 'code' => 'E-1', 'name' => 'Asbestos management' },
              { 'code' => 'C-15', 'name' => 'Audio visual (AV) equipment maintenance' },
              { 'code' => 'C-10', 'name' => 'Automated barrier control system maintenance' },
              { 'code' => 'E-9', 'name' => 'Building information modelling and government soft landings' },
              { 'code' => 'C-11', 'name' => 'Building management system (BMS) maintenance' },
              { 'code' => 'H-12', 'name' => 'Cable management' },
              { 'code' => 'M-1', 'name' => 'CAFM system' },
              { 'code' => 'I-3', 'name' => 'Car park management and booking' },
              { 'code' => 'C-14', 'name' => 'Catering equipment maintenance' },
              { 'code' => 'J-2', 'name' => 'CCTV / alarm monitoring' },
              { 'code' => 'L-1', 'name' => 'Childcare facility' },
              { 'code' => 'F-1', 'name' => 'Chilled potable water' },
              { 'code' => 'K-1', 'name' => 'Classified waste' },
              { 'code' => 'G-8', 'name' => 'Cleaning of communications and equipment rooms' },
              { 'code' => 'G-13', 'name' => 'Cleaning of curtains and window blinds' },
              { 'code' => 'G-5', 'name' => 'Cleaning of external areas' },
              { 'code' => 'G-2', 'name' => 'Cleaning of integral barrier mats' },
              { 'code' => 'K-5', 'name' => 'Clinical waste' },
              { 'code' => 'H-7', 'name' => 'Clocks' },
              { 'code' => 'E-5', 'name' => 'Compliance plans, specialist surveys and audits' },
              { 'code' => 'E-6', 'name' => 'Conditions survey' },
              { 'code' => 'J-3', 'name' => 'Control of access and security passes' },
              { 'code' => 'H-3', 'name' => 'Courier booking and external distribution' },
              { 'code' => 'D-6', 'name' => 'Cut flowers and christmas trees' },
              { 'code' => 'G-4', 'name' => 'Deep (periodic) cleaning' },
              { 'code' => 'F-3', 'name' => 'Deli/coffee bar' },
              { 'code' => 'L-3', 'name' => 'Driver and vehicle service' },
              { 'code' => 'E-7', 'name' => 'Electrical testing' },
              { 'code' => 'J-4', 'name' => 'Emergency response' },
              { 'code' => 'J-9', 'name' => 'Enhanced security requirements' },
              { 'code' => 'C-3', 'name' => 'Environmental cleaning service' },
              { 'code' => 'F-4', 'name' => 'Events and functions' },
              { 'code' => 'K-7', 'name' => 'Feminine hygiene waste' },
              { 'code' => 'C-4', 'name' => 'Fire detection and firefighting systems maintenance' },
              { 'code' => 'E-8', 'name' => 'Fire risk assessments' },
              { 'code' => 'L-4', 'name' => 'First aid and medical service' },
              { 'code' => 'L-5', 'name' => 'Flag flying service' },
              { 'code' => 'L-8', 'name' => 'Footwear cobbling services' },
              { 'code' => 'F-5', 'name' => 'Full service restaurant' },
              { 'code' => 'H-10', 'name' => 'Furniture management' },
              { 'code' => 'K-2', 'name' => 'General waste' },
              { 'code' => 'D-1', 'name' => 'Grounds maintenance services' },
              { 'code' => 'L-7', 'name' => 'Hairdressing services' },
              { 'code' => 'H-4', 'name' => 'Handyman services' },
              { 'code' => 'K-4', 'name' => 'Hazardous waste' },
              { 'code' => 'N-1', 'name' => 'Helpdesk services' },
              { 'code' => 'C-13', 'name' => 'High voltage (HV) and switchgear maintenance' },
              { 'code' => 'F-6', 'name' => 'Hospitality and meetings' },
              { 'code' => 'G-10', 'name' => 'Housekeeping' },
              { 'code' => 'L-10', 'name' => 'Housing and residential accommodation management' },
              { 'code' => 'C-7', 'name' => 'Internal and external building fabric maintenance' },
              { 'code' => 'H-2', 'name' => 'Internal messenger service' },
              { 'code' => 'D-5', 'name' => 'Internal planting' },
              { 'code' => 'G-11', 'name' => 'It equipment cleaning' },
              { 'code' => 'L-6', 'name' => 'Journal, magazine and newspaper supply' },
              { 'code' => 'J-10', 'name' => 'Key holding' },
              { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
              { 'code' => 'G-16', 'name' => 'Linen and laundry services' },
              { 'code' => 'J-11', 'name' => 'Lock up / open up of buyer premises' },
              { 'code' => 'C-20', 'name' => 'Locksmith services' },
              { 'code' => 'C-17', 'name' => 'Mail room equipment maintenance' },
              { 'code' => 'H-1', 'name' => 'Mail services' },
              { 'code' => 'J-6', 'name' => 'Management of visitors and passes' },
              { 'code' => 'J-1', 'name' => 'Manned guarding service' },
              { 'code' => 'C-1', 'name' => 'Mechanical and electrical engineering maintenance' },
              { 'code' => 'G-14', 'name' => 'Medical and clinical cleaning' },
              { 'code' => 'K-6', 'name' => 'Medical waste' },
              { 'code' => 'G-3', 'name' => 'Mobile cleaning services' },
              { 'code' => 'H-5', 'name' => 'Move and space management - internal moves' },
              { 'code' => 'C-18', 'name' => 'Office machinery servicing and maintenance' },
              { 'code' => 'F-7', 'name' => 'Outside catering' },
              { 'code' => 'J-5', 'name' => 'Patrols (fixed or static guarding)' },
              { 'code' => 'J-12', 'name' => 'Patrols (mobile via a specific visiting vehicle)' },
              { 'code' => 'G-15', 'name' => 'Pest control services' },
              { 'code' => 'C-9', 'name' => 'Planned / group re-lamping service' },
              { 'code' => 'E-4', 'name' => 'Portable appliance testing' },
              { 'code' => 'H-15', 'name' => 'Portable washroom solutions' },
              { 'code' => 'H-6', 'name' => 'Porterage' },
              { 'code' => 'D-3', 'name' => 'Professional snow & ice clearance' },
              { 'code' => 'L-9', 'name' => 'Provision of chaplaincy support services' },
              { 'code' => 'G-9', 'name' => 'Reactive cleaning (outside cleaning operational hours)' },
              { 'code' => 'J-7', 'name' => 'Reactive guarding' },
              { 'code' => 'C-8', 'name' => 'Reactive maintenance services' },
              { 'code' => 'I-1', 'name' => 'Reception service' },
              { 'code' => 'K-3', 'name' => 'Recycled waste' },
              { 'code' => 'H-13', 'name' => 'Reprographics service' },
              { 'code' => 'D-4', 'name' => 'Reservoirs, ponds, river walls and water features maintenance' },
              { 'code' => 'F-10', 'name' => 'Residential catering services' },
              { 'code' => 'F-2', 'name' => 'Retail services / convenience store' },
              { 'code' => 'G-1', 'name' => 'Routine cleaning' },
              { 'code' => 'C-6', 'name' => 'Security, access and intruder systems maintenance' },
              { 'code' => 'H-8', 'name' => 'Signage' },
              { 'code' => 'H-11', 'name' => 'Space management' },
              { 'code' => 'G-12', 'name' => 'Specialist cleaning' },
              { 'code' => 'C-22', 'name' => 'Specialist maintenance services' },
              { 'code' => 'L-2', 'name' => 'Sports and leisure' },
              { 'code' => 'C-12', 'name' => 'Standby power system maintenance' },
              { 'code' => 'E-3', 'name' => 'Statutory inspections' },
              { 'code' => 'H-14', 'name' => 'Stores management' },
              { 'code' => 'I-2', 'name' => 'Taxi booking service' },
              { 'code' => 'C-16', 'name' => 'Television cabling maintenance' },
              { 'code' => 'L-11', 'name' => 'Training establishment management and booking service' },
              { 'code' => 'D-2', 'name' => 'Tree surgery (arboriculture)' },
              { 'code' => 'F-8', 'name' => 'Trolley service' },
              { 'code' => 'F-9', 'name' => 'Vending services (food & beverage)' },
              { 'code' => 'C-2', 'name' => 'Ventilation and air conditioning system maintenance' },
              { 'code' => 'C-19', 'name' => 'Voice announcement system maintenance' },
              { 'code' => 'I-4', 'name' => 'Voice announcement system operation' },
              { 'code' => 'E-2', 'name' => 'Water hygiene maintenance' },
              { 'code' => 'G-7', 'name' => 'Window cleaning (external)' },
              { 'code' => 'G-6', 'name' => 'Window cleaning (internal)' }
            ],
            :'fm-building-type' => 'General office - Customer Facing'
          },
          status: 'Incomplete'
        )
      ]

      # populate db with dub buildings
      # rubocop:disable RSpec/InstanceVariable
      @selected_buildings2.each do |b|
        FacilitiesManagement::Buildings.delete b.id
        new_building = FacilitiesManagement::Buildings.new(
          id: b.id,
          user_id: Base64.encode64('test@example.com'),
          updated_by: Base64.encode64('test@example.com'),
          building_json: b.building_json
        )
        new_building[:building_json]['building-type'] = 'General office - Customer Facing',
        new_building[:building_json]['address'][:'fm-nuts-region'] = 'Westminster'

        new_building.save
      rescue StandardError => e
        Rails.logger.warn "Couldn't update new building id: #{e}"
      end
    end
    # rubocop:enable Layout/MultilineHashBraceLayout
    # rubocop:enable Layout/AlignArray
    # rubocop:enable Style/HashSyntax

    after :all do
      # teardown
      @selected_buildings2.each do |b|
        FacilitiesManagement::Buildings.delete b.id
      rescue StandardError => e
        Rails.logger.warn "Couldn't delete new building id: #{e}"
      end
    end
    # rubocop:enable RSpec/BeforeAfterAll
    # rubocop:enable RSpec/InstanceVariable

    # rubocop:disable RSpec/ExampleLength
    # rubocop:disable RSpec/InstanceVariable
    it 'create a direct-award report' do
      user_email = 'test@example.com'
      start_date = DateTime.now.utc

      uvals.map!(&:deep_symbolize_keys)

      report = described_class.new(start_date, user_email, data)

      rates = CCS::FM::Rate.read_benchmark_rates
      rate_card = CCS::FM::RateCard.latest

      results = {}
      report_results = {}
      supplier_names = rate_card.data['Prices'].keys
      supplier_names.each do |supplier_name|
        report_results[supplier_name] = {}
        # e.g. dummy supplier_name = 'Hickle-Schinner'
        report.calculate_services_for_buildings @selected_buildings2, uvals, rates, rate_card, supplier_name, report_results[supplier_name]
        results[supplier_name] = report.direct_award_value
      end

      sorted_list = results.sort_by { |_k, v| v }
      expect(sorted_list.first[0]).to eq 'Cartwright and Sons'
      expect(sorted_list.first[1].round(2)).to eq 1469124.32

      supplier_name = sorted_list.first[0]
      expect(report_results[supplier_name][report_results[supplier_name].keys.second].count).to eq 21

      spreadsheet = FacilitiesManagement::DirectAwardSpreadsheet.new supplier_name, report_results[supplier_name], rate_card

      IO.write('/tmp/direct_award_prices_2.xlsx', spreadsheet.to_xlsx)

      # uvals.each(&:deep_symbolize_keys!)
      buildings_ids = uvals.collect { |u| u[:building_id] }.compact.uniq

      building_ids_with_service_codes2 = buildings_ids.collect do |b|
        services_per_building = uvals.select { |u| u[:building_id] == b }.collect { |u| u[:service_code] }
        { building_id: b.downcase, service_codes: services_per_building }
      end

      spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new(building_ids_with_service_codes2, uvals)
      spreadsheet = spreadsheet_builder.build
      # render xlsx: spreadsheet.to_stream.read, filename: 'deliverable_matrix', format: # 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
      IO.write('/tmp/deliverable_matrix_2.xlsx', spreadsheet.to_stream.read)
    end
    # rubocop:enable RSpec/InstanceVariable
    # rubocop:enable RSpec/ExampleLength
  end

  # rubocop:disable RSpec/ExampleLength
  it 'can calculate a direct award procurement' do
    # p '*********'
    # p CCS::FM::UnitsOfMeasurement.all.count
    # p '*********'

    uoms = CCS::FM::UnitsOfMeasurement.all.group_by(&:service_usage)
    uom2 = {}
    uoms.map { |u| u[0].each { |k| uom2[k] = u[1] } }

    FacilitiesManagement::Service
      .all
      .sort_by { |s| [s.work_package_code, s.code[s.code.index('.') + 1..-1].to_i] }.each do |service|
    end

    # input params
    vals = {}
    vals['tupe'] = 'no' # 'yes' : 'no',
    vals['contract-length'] = 3
    vals['gia'] = 12345
    vals['isLondon'] = true
    id = SecureRandom.uuid

    # p 'procurement info'

    start_date = DateTime.now.utc
    procurement =
      {
        'start_date' => start_date,
        'is-tupe' => vals['tupe'] ? 'yes' : 'no',
        'fm-contract-length' => vals['contract-length']
      }
    # set data2['posted_locations']
    procurement[:posted_locations] = ['UKC14', 'UKC21', 'UKC22', 'UKD11']
    # procurement['posted_locations'] = vals.keys.select { |k| k.start_with?('region-') }.collect { |k| vals[k] }

    # p 'Buildings info'
    b =
      {
        id: id,
        gia: vals['gia'].to_f,
        isLondon: vals['isLondon'] ? 'Yes' : 'No',
        fm_building_type: 'General office - Customer Facing'
      }

    all_buildings =
      [
        OpenStruct.new(building_json: b)
      ]

    # p 'There are #{uom2.count} services with a specific * units of measure *'
    # p 'There are #{Nuts3Region.all.count} NUTS3 regions'

    # --------
    rate_card = CCS::FM::RateCard.latest
    rates = CCS::FM::Rate.read_benchmark_rates

    # ------
    uom_vals = []
    # posted_services = FacilitiesManagement::Service.all.map(&:code)
    posted_services = uom2.keys
    posted_services.each do |s|
      uom_vals <<
        {
          user_id: 'test@example.com',
          service_code: s,
          uom_value: 10,
          building_id: id,
        }
    end
    # ------

    report = described_class.new(start_date, 'test@example.com', procurement)

    results = {}
    supplier_names = rate_card.data['Prices'].keys
    supplier_names.each do |supplier_name|
      # dummy_supplier_name = 'Hickle-Schinner'
      results[supplier_name] = {}
      report.calculate_services_for_buildings all_buildings, uom_vals, rates, rate_card, supplier_name, results[supplier_name]
      results[supplier_name][:direct_award_value] = report.direct_award_value
    end

    # p report.direct_award_value
    expect(report.direct_award_value).to be > -1
  end
  # rubocop:enable RSpec/ExampleLength
end
