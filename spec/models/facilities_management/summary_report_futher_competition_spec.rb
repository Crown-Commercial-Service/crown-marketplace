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

  let(:user) { create(:user, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }

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

  context 'and dummy buildings to a db' do
    let(:selected_buildings2) do
      [OpenStruct.new(
        id: 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b',
        user_id: user.id,
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
            'fm-nuts-region' => 'Westminster'
          },
          'isLondon' => false,
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
          ],
          :'fm-building-type' => 'General office - Customer Facing',
          'building-type' => 'General office - Customer Facing'
        },
        status: 'Incomplete'
      ),

       OpenStruct.new(
         id: 'e60f5b57-5f15-604c-b729-a689ede34a99',
         user_id: user.id,
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
             'fm-nuts-region' => 'Westminster'
           },
           'isLondon' => false,
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
           ],
           :'fm-building-type' => 'General office - Customer Facing',
           'building-type' => 'General office - Customer Facing'
         },
         status: 'Incomplete'
       )]
    end

    before do
      selected_buildings2.each do |b|
        FacilitiesManagement::Buildings.delete b.id
        new_building = FacilitiesManagement::Buildings.new(
          id: b.id,
          user_id: Base64.encode64('test@example.com'),
          updated_by: Base64.encode64('test@example.com'),
          building_json: b.building_json
        )
        new_building.save
      rescue StandardError => e
        Rails.logger.warn "Couldn't update new building id: #{e}"
      end
    end

    # rubocop:disable RSpec/ExampleLength
    it 'create a further competition excel,very worksheets are there' do
      user_email = 'test@example.com'
      start_date = DateTime.now.utc

      uvals.map!(&:deep_symbolize_keys)

      data[:'fm-contract-length'] = 1

      report = described_class.new(start_date: start_date, user_email: user_email, data: data)

      results = {}
      report_results = {}
      supplier_names = CCS::FM::RateCard.latest.data[:Prices].keys
      supplier_names.each do |supplier_name|
        report_results[supplier_name] = {}
        report.calculate_services_for_buildings selected_buildings2, uvals, supplier_name, report_results[supplier_name]
        results[supplier_name] = report.direct_award_value
      end

      # create deliverable matrix spreadsheet
      buildings_ids = uvals.collect { |u| u[:building_id] }.compact.uniq

      building_ids_with_service_codes2 = buildings_ids.collect do |b|
        services_per_building = uvals.select { |u| u[:building_id] == b }.collect { |u| u[:service_code] }
        { building_id: b.downcase, service_codes: services_per_building }
      end

      spreadsheet_builder = FacilitiesManagement::FurtherCompetitionSpreadsheetCreator.new(building_ids_with_service_codes2, uvals)

      report = instance_double('FacilitiesManagement::SummaryReport.new')

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
  end
end
