require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  subject(:report) { described_class.new(procurement.id) }

  let(:contract) { create(:facilities_management_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }
  let(:supplier) { create(:ccs_fm_supplier_with_lots, :with_supplier_name, name: 'Wolf-Wiza') }

  let(:user) do
    create(:user, :without_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n')
  end

  let(:procurement) do
    create(:facilities_management_procurement_with_extension_periods, user: user, initial_call_off_period: 7).tap do |proc|
      create(:facilities_management_procurement_building, procurement: proc, building: selected_building1)
      create(:facilities_management_procurement_building, procurement: proc, building: selected_building2)
      create(:facilities_management_procurement_building, procurement: proc, building: selected_building3)
    end
  end

  let(:supplier_names) do
    [:"Wolf-Wiza",
     :"Bogan-Koch",
     :"O'Keefe LLC",
     :"Treutel LLC",
     :"Hirthe-Mills",
     :"Kemmer Group",
     :"Mayer-Russel",
     :"Bode and Sons",
     :"Collier Group",
     :"Hickle-Schinner",
     :"Leffler-Strosin",
     :"Dickinson-Abbott",
     :"O'Keefe-Mitchell",
     :"Schmeler-Leuschke",
     :"Abernathy and Sons",
     :"Cartwright and Sons",
     :"Dare, Heaney and Kozey",
     :"Rowe, Hessel and Heller",
     :"Kulas, Schultz and Moore",
     :"Walsh, Murphy and Gaylord",
     :"Shields, Ratke and Parisian",
     :"Ullrich, Ratke and Botsford",
     :"Lebsack, Vandervort and Veum",
     :"Marvin, Kunde and Cartwright",
     :"Kunze, Langworth and Parisian",
     :"Halvorson, Corwin and O'Connell"]
  end

  let(:supplier_name) { supplier_names.last }

  let(:building1_json) do
    { 'id' => 'e7eed6f6-5ef0-e387-ee35-6c1d39feb8a9',
      'gia' => 1234,
      'name' => 'c4',
      'region' => 'London',
      'building-type' => 'Warehouses',
      'address' => {
        'fm-address-town' => 'London',
        'fm-address-line-1' => '1 Horseferry Road',
        'fm-address-postcode' => 'SW1P 2BA',
        'fm-address-region-code' => 'UKH1'
      },
      'isLondon' => false,
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
      'fm-building-type' => 'General office - Customer Facing' }
  end

  let(:building2_json) do
    { 'id' => 'd6110725-33ed-b20d-47b2-d2e0cbc3ac83',
      'gia' => 2000,
      'name' => 'Victoria Station',
      'region' => 'London',
      'address_region_code' => 'UKH1',
      'building-type' => 'Warehouses',
      'address' => {
        'fm-address-town' => 'London',
        'fm-address-line-1' => '121 Buckingham Palace Road',
        'fm-address-postcode' => 'SW1W 9SZ',
        'fm-address-region-code' => 'UKH1'
      },
      'isLondon' => false, 'services' => [
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
        { 'code' => 'G-6', 'name' => 'Window cleaning (internal)' },
        { 'code' => 'F-5', 'name' => 'Full service restaurant' }
      ],
      'fm-building-type' => 'General office - Customer Facing' }
  end

  let(:building3_json) do
    { 'id' => '8d54a907-4508-dd74-8ab5-ada3e4551f17',
      'gia' => 12345,
      'name' => 'ccs',
      'region' => 'London',
      'address_region_code' => 'UKH1',
      'building-type' => 'Warehouses',
      'address' => {
        'fm-address-town' => 'London',
        'fm-address-line-1' => '151 Buckingham Palace Road',
        'fm-address-postcode' => 'SW1W 9SZ',
        'fm-address-region-code' => 'UKH1'
      },
      'isLondon' => false, 'services' => [
        { 'code' => 'J-8', 'name' => 'Additional security services' },
        { 'code' => 'H-16', 'name' => 'Administrative support services' },
        { 'code' => 'C-21', 'name' => 'Airport and aerodrome maintenance services' },
        { 'code' => 'H-9', 'name' => 'Archiving (on-site)' },
        { 'code' => 'E-1', 'name' => 'Asbestos management' },
        { 'code' => 'C-15', 'name' => 'Audio visual (AV) equipment maintenance' },
        { 'code' => 'C-10', 'name' => 'Automated barrier control system maintenance' },
        { 'code' => 'E-9', 'name' => 'Building information modelling and government soft landings' },
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
        { 'code' => 'G-6', 'name' => 'Window cleaning (internal)' },
        { 'code' => 'C-11', 'name' => 'Building management system (BMS) maintenance' },
        { 'code' => 'I-1', 'name' => 'Reception service' }
      ],
      'fm-building-type' => 'General office - Customer Facing' }
  end

  let(:selected_building1) do
    create(:facilities_management_building, user: user, status: 'Incomplete', updated_by: user, building_json: building1_json)
  end

  let(:selected_building2) do
    create(:facilities_management_building, user: user, status: 'Incomplete', updated_by: user, building_json: building2_json)
  end

  let(:selected_building3) do
    create(:facilities_management_building, user: user, status: 'Incomplete', updated_by: user, building_json: building3_json)
  end

  describe '#calculate_services_for_buildings, #direct_award_value' do
    subject(:direct_award_values) do
      supplier_names.each_with_object({}) do |supplier_name, results|
        results[supplier_name] = {}
        report.calculate_services_for_buildings supplier_name
        results[supplier_name] = report.direct_award_value
      end
    end

    it 'calculates correct values' do
      expect(direct_award_values[:'Wolf-Wiza'].round).to eq 74_981
      expect(direct_award_values[:'Dickinson-Abbott'].round).to eq 145_944
      expect(direct_award_values[:"Halvorson, Corwin and O'Connell"].round).to eq 31_673
    end
  end

  describe FacilitiesManagement::DirectAwardSpreadsheet do
    subject(:wb) do
      spreadsheet = described_class.new contract.id
      path = '/tmp/direct_award_prices.xlsx'
      IO.write(path, spreadsheet.to_xlsx)
      Roo::Excelx.new(path)
    end

    it 'Verify Unit Of Measure column in table 1' do
      expect(wb.sheet('Contract Rate Card').row(4)[0]).to eq 'C.1'
      expect(wb.sheet('Contract Rate Card').row(4)[1]).to eq 'Mechanical and Electrical Engineering Maintenance - Standard A'
    end

    # rubocop:disable RSpec/MultipleExpectations
    # God only knows why rubocop thinks this is too many expectations (It's fine with the one above)
    it 'Verify building columns in table 1' do
      expect(wb.sheet('Contract Rate Card').row(3)[3]).to eq 'Warehouses'
      expect(wb.sheet('Contract Rate Card').row(4)[3].round(4)).to eq 2.3346
      expect(wb.sheet('Contract Rate Card').row(3)[4]).to eq 'General office - Customer Facing'
      expect(wb.sheet('Contract Rate Card').row(4)[4].round(4)).to eq 2.3346
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
