require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:procurement_with_buildings) { create(:facilities_management_procurement_with_contact_details_with_buildings) }
  let(:spreadsheet_builder) { FacilitiesManagement::FurtherCompetitionSpreadsheetCreator.new(procurement_with_buildings.id) }

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

  let(:user) { create(:user, :without_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }

  let(:uvals) do
    [
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'E.4', 'uom_value' => '1', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.1', 'uom_value' => '2', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.3', 'uom_value' => '3', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.5', 'uom_value' => '4', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.4', 'uom_value' => '5', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.5', 'uom_value' => '6', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.1', 'uom_value' => '7', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.2', 'uom_value' => '8', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.3', 'uom_value' => '9', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.4', 'uom_value' => '10', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.1', 'uom_value' => '11', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.2', 'uom_value' => '12', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.3', 'uom_value' => '13', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.4', 'uom_value' => '14', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.5', 'uom_value' => '15', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.6', 'uom_value' => '16', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.1', 'uom_value' => '17', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.2', 'uom_value' => '18', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.3', 'uom_value' => '19', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.7', 'uom_value' => '20', :service_standard => 'A', 'building_id' => 'e60f5b57-5f15-604c-b729-a689ede34a99', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'E.4', 'uom_value' => '30', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.1', 'uom_value' => '31', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.3', 'uom_value' => '32', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'G.5', 'uom_value' => '33', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.4', 'uom_value' => '34', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'H.5', 'uom_value' => '35', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.1', 'uom_value' => '36', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.2', 'uom_value' => '37', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.3', 'uom_value' => '38', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'I.4', 'uom_value' => '39', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.1', 'uom_value' => '40', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.2', 'uom_value' => '41', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.3', 'uom_value' => '42', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.4', 'uom_value' => '43', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.5', 'uom_value' => '44', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'J.6', 'uom_value' => '45', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.1', 'uom_value' => '46', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.2', 'uom_value' => '47', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', 'service_code' => 'K.3', 'uom_value' => '48', :service_standard => 'A', 'building_id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', 'title_text' => nil, 'example_text' => nil },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :service_standard => 'A', :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :service_standard => 'A', :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :service_standard => 'A', :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :service_standard => 'A', :building_id => 'e60f5b57-5f15-604c-b729-a689ede34a99', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 5, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 4, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'C.5', :uom_value => 6, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'The sum total of number of floors per lift' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'M.1', :uom_value => 1000, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'CAFM' },
      { :user_id => 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n', :service_code => 'N.1', :uom_value => 1000, :service_standard => 'A', :building_id => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b', :title_text => nil, :example_text => nil, :spreadsheet_label => 'Help' }
    ]
  end
  # rubocop:enable Style/HashSyntax

  context 'when testing FC report methods' do
    # rubocop:disable RSpec/ExampleLength
    it 'create a further competition excel,very worksheets are there' do
      report = described_class.new(procurement_with_buildings.id)

      supplier_names = CCS::FM::RateCard.latest.data[:Prices].keys
      supplier_names.each do |supplier_name|
        report.calculate_services_for_buildings(supplier_name, true, :fc)
        expect(report.direct_award_value).to be > 0
      end

      expect(report.assessed_value).to eq 1558.9402171200002

      #  uom_values = report.uom_values(:fc)  # TODO this did not work due to buildings factory array within an array type of issue

      spreadsheet = spreadsheet_builder.build
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
  end

  describe 'assessed_value for FC sub-lots', skip: true do
    let(:code) { nil }
    let(:code1) { nil }
    let(:code2) { nil }
    let(:lift_data) { nil }
    let(:estimated_annual_cost) { 7000000 }
    let(:estimated_cost_known) { true }
    let(:service_standard) { 'A' }
    let(:procurement_building_service) do
      create(:facilities_management_procurement_building_service,
             code: code,
             service_standard: service_standard,
             lift_data: lift_data,
             procurement_building: create(:facilities_management_procurement_building_no_services,
                                          building_id: create(:facilities_management_building_london).id,
                                          procurement: create(:facilities_management_procurement_no_procurement_buildings,
                                                              estimated_annual_cost: estimated_annual_cost,
                                                              estimated_cost_known: estimated_cost_known)))
    end
    let(:procurement_building_service_1) do
      create(:facilities_management_procurement_building_service,
             code: code1,
             procurement_building: procurement_building_service.procurement_building)
    end
    let(:procurement_building_service_2) do
      create(:facilities_management_procurement_building_service,
             code: code2,
             procurement_building: procurement_building_service_1.procurement_building)
    end

    let(:report) { described_class.new(procurement_building_service_2.procurement_building.procurement.id) }

    before do
      report.calculate_services_for_buildings
    end

    context 'when framework price for at least one service is missing' do
      let(:code) { 'C.5' }
      let(:lift_data) { %w[1000 1000 1000 1000] }
      let(:code1) { 'G.9' } # no fw price
      let(:code2) { 'C.7' } # no fw price

      context 'when variance between the Customer & BM prices and the available FW prices is >|30%|' do
        let(:estimated_annual_cost) { 1 }
        let(:service_standard) { 'B' } # C.5 no fw price (standard B)

        it 'uses BM and Customer prices only' do
          expect(report.assessed_value.round(2)).to eq(((report.buyer_input + report.sum_benchmark) / 2.0).round(2))
        end
      end

      context 'when variance between the Customer & BM prices and the available FW prices is >|-30%| and <|30%|' do
        let(:estimated_annual_cost) { 1850843 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark + report.buyer_input) / 3.0).round(2))
        end
      end

      context 'when variance between the Customer & BM prices and the available FW prices is and <|-30%|' do
        let(:estimated_annual_cost) { 125084300 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.buyer_input + report.sum_benchmark) / 2.0).round(2))
        end
      end

      context 'when no Customer price' do
        let(:estimated_annual_cost) { nil }
        let(:estimated_cost_known) { false }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark) / 2.0).round(2))
        end
      end
    end

    context 'when at least one service missing framework price and at least one service is missing benchmark price' do
      let(:code) { 'C.5' }
      let(:lift_data) { %w[1000 1000 1000 1000] }
      let(:code1) { 'G.9' } # no fw price
      let(:code2) { 'G.8' } # no fw & no bm price

      context 'when variance between FM & BM and Customer input is >|30%|' do
        let(:lift_data) { %w[10] }
        let(:estimated_annual_cost) { 1 }

        it 'uses Customer price only' do
          expect(report.assessed_value.round(2)).to eq(report.buyer_input.round(2))
        end
      end

      context 'when variance between FM & BM and Customer input is >|-30%| and <|30%|' do
        let(:estimated_annual_cost) { 1227921 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark + report.buyer_input) / 3.0).round(2))
        end
      end

      context 'when variance between FM & BM and Customer input is <|-30%|' do
        let(:estimated_annual_cost) { 2000 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(report.buyer_input.round(2))
        end
      end

      context 'when no Customer price' do
        let(:estimated_annual_cost) { nil }
        let(:estimated_cost_known) { false }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark) / 2.0).round(2))
        end
      end
    end
  end
end
