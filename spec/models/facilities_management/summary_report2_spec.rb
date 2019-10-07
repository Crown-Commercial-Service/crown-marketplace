require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  # before do
  # end

  let(:building1) do
    { 'id' => '5D0901B0-E8C1-C6A7-191D-4710C4514EE1',
      'gia' => 12345,
      'name' => 'ccs',
      'region' => 'London',
      'address' => { 'fm-address-town' => 'London', 'fm-address-line-1' => '151 Buckingham Palace Road', 'fm-address-postcode' => 'SW1W 9SZ' },
      'isLondon' => 'No',
      :fm_building_type => 'General office - Customer Facing' }
  end

  let(:building2) do
    { 'id' => 'AB5059BB-9525-7372-4A9E-074F1852BF66',
      'gia' => 123, 'name' => 'home',
      'region' => 'Region not found for this postcode',
      'address' => { 'fm-address-town' => 'Glagsow', 'fm-address-line-1' => '12 Mansionhouse Road', 'fm-address-postcode' => 'G32 0RP' },
      'isLondon' => 'No',
      'services' => [
        { 'code' => 'C-21', 'name' => 'Airport and aerodrome maintenance services' },
        { 'code' => 'C-15', 'name' => 'Audio visual (AV) equipment maintenance' },
        { 'code' => 'C-10', 'name' => 'Automated barrier control system maintenance' },
        { 'code' => 'C-11', 'name' => 'Building management system (BMS) maintenance' },
        { 'code' => 'C-14', 'name' => 'Catering equipment maintenance' },
        { 'code' => 'C-3', 'name' => 'Environmental cleaning' },
        { 'code' => 'C-4', 'name' => 'Fire detection and firefighting systems maintenance' },
        { 'code' => 'C-13', 'name' => 'High voltage (HV) and switchgear maintenance' },
        { 'code' => 'C-7', 'name' => 'Internal and external building fabric maintenance' },
        { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
        { 'code' => 'C-20', 'name' => 'Locksmith services' },
        { 'code' => 'C-17', 'name' => 'Mail room equipment maintenance' },
        { 'code' => 'C-1', 'name' => 'Mechanical and electrical engineering maintenance' },
        { 'code' => 'C-18', 'name' => 'Office machinery servicing and maintenance' },
        { 'code' => 'C-9', 'name' => 'Planned / group re-lamping service' },
        { 'code' => 'C-8', 'name' => 'Reactive maintenance services' },
        { 'code' => 'C-6', 'name' => 'Security, access and intruder systems maintenance' },
        { 'code' => 'C-22', 'name' => 'Specialist maintenance services' },
        { 'code' => 'C-12', 'name' => 'Standby power system maintenance' },
        { 'code' => 'C-16', 'name' => 'Television cabling maintenance' },
        { 'code' => 'C-2', 'name' => 'Ventilation and air conditioning system maintenance' },
        { 'code' => 'C-19', 'name' => 'Voice announcement system maintenance' },
        { 'code' => 'D-6', 'name' => 'Cut flowers and christmas trees' },
        { 'code' => 'D-1', 'name' => 'Grounds maintenance services' },
        { 'code' => 'D-5', 'name' => 'Internal planting' },
        { 'code' => 'D-3', 'name' => 'Professional snow & ice clearance' },
        { 'code' => 'D-4', 'name' => 'Reservoirs, ponds, river walls and water features maintenance' },
        { 'code' => 'D-2', 'name' => 'Tree surgery (arboriculture)' },
        { 'code' => 'E-1', 'name' => 'Asbestos management' },
        { 'code' => 'E-9', 'name' => 'Building information modelling and government soft landings' },
        { 'code' => 'E-5', 'name' => 'Compliance plans, specialist surveys and audits' },
        { 'code' => 'E-6', 'name' => 'Conditions survey' },
        { 'code' => 'E-7', 'name' => 'Electrical testing' },
        { 'code' => 'E-8', 'name' => 'Fire risk assessments' },
        { 'code' => 'E-4', 'name' => 'Portable appliance testing' },
        { 'code' => 'E-3', 'name' => 'Statutory inspections' },
        { 'code' => 'E-2', 'name' => 'Water hygiene maintenance' },
        { 'code' => 'F-1', 'name' => 'Chilled potable water' },
        { 'code' => 'F-2', 'name' => 'Retail services / convenience store' },
        { 'code' => 'F-3', 'name' => 'Deli/coffee bar' },
        { 'code' => 'F-4', 'name' => 'Events and functions' },
        { 'code' => 'F-5', 'name' => 'Full service restaurant' },
        { 'code' => 'F-6', 'name' => 'Hospitality and meetings' },
        { 'code' => 'F-7', 'name' => 'Outside catering' },
        { 'code' => 'F-8', 'name' => 'Trolley service' },
        { 'code' => 'F-9', 'name' => 'Vending services (food & beverage)' },
        { 'code' => 'F-10', 'name' => 'Residential catering services' },
        { 'code' => 'G-8', 'name' => 'Cleaning of communications and equipment rooms' },
        { 'code' => 'G-13', 'name' => 'Cleaning of curtains and window blinds' },
        { 'code' => 'G-5', 'name' => 'Cleaning of external areas' },
        { 'code' => 'G-2', 'name' => 'Cleaning of integral barrier mats' },
        { 'code' => 'G-4', 'name' => 'Deep (periodic) cleaning' },
        { 'code' => 'G-10', 'name' => 'Housekeeping' },
        { 'code' => 'G-11', 'name' => 'It equipment cleaning' },
        { 'code' => 'G-16', 'name' => 'Linen and laundry services' },
        { 'code' => 'G-14', 'name' => 'Medical and clinical cleaning' },
        { 'code' => 'G-3', 'name' => 'Mobile cleaning services' },
        { 'code' => 'G-15', 'name' => 'Pest control services' },
        { 'code' => 'G-9', 'name' => 'Reactive cleaning (outside cleaning operational hours)' },
        { 'code' => 'G-1', 'name' => 'Routine cleaning' },
        { 'code' => 'G-12', 'name' => 'Specialist cleaning' },
        { 'code' => 'G-7', 'name' => 'Window cleaning (external)' },
        { 'code' => 'G-6', 'name' => 'Window cleaning (internal)' },
        { 'code' => 'H-16', 'name' => 'Administrative support services' },
        { 'code' => 'H-9', 'name' => 'Archiving (on-site)' },
        { 'code' => 'H-12', 'name' => 'Cable management' },
        { 'code' => 'H-7', 'name' => 'Clocks' },
        { 'code' => 'H-3', 'name' => 'Courier booking and external distribution' },
        { 'code' => 'H-10', 'name' => 'Furniture management' },
        { 'code' => 'H-4', 'name' => 'Handyman services' },
        { 'code' => 'H-2', 'name' => 'Internal messenger service' },
        { 'code' => 'H-1', 'name' => 'Mail services' },
        { 'code' => 'H-5', 'name' => 'Move and space management - internal moves' },
        { 'code' => 'H-15', 'name' => 'Portable washroom solutions' },
        { 'code' => 'H-6', 'name' => 'Porterage' },
        { 'code' => 'H-13', 'name' => 'Reprographics service' },
        { 'code' => 'H-8', 'name' => 'Signage' },
        { 'code' => 'H-11', 'name' => 'Space management' },
        { 'code' => 'H-14', 'name' => 'Stores management' },
        { 'code' => 'I-3', 'name' => 'Car park management and booking' },
        { 'code' => 'I-1', 'name' => 'Reception service' },
        { 'code' => 'I-2', 'name' => 'Taxi booking service' },
        { 'code' => 'I-4', 'name' => 'Voice announcement system operation' },
        { 'code' => 'J-8', 'name' => 'Additional security services' },
        { 'code' => 'J-2', 'name' => 'Cctv / alarm monitoring' },
        { 'code' => 'J-3', 'name' => 'Control of access and security passes' },
        { 'code' => 'J-4', 'name' => 'Emergency response' },
        { 'code' => 'J-9', 'name' => 'Enhanced security requirements' },
        { 'code' => 'J-10', 'name' => 'Key holding' },
        { 'code' => 'J-11', 'name' => 'Lock up / open up of buyer premises' },
        { 'code' => 'J-6', 'name' => 'Management of visitors and passes' },
        { 'code' => 'J-1', 'name' => 'Manned guarding service' },
        { 'code' => 'J-5', 'name' => 'Patrols (fixed or static guarding)' },
        { 'code' => 'J-12', 'name' => 'Patrols (mobile via a specific visiting vehicle)' },
        { 'code' => 'J-7', 'name' => 'Reactive guarding' },
        { 'code' => 'K-1', 'name' => 'Classified waste' },
        { 'code' => 'K-5', 'name' => 'Clinical waste' },
        { 'code' => 'K-7', 'name' => 'Feminine hygiene waste' },
        { 'code' => 'K-2', 'name' => 'General waste' },
        { 'code' => 'K-4', 'name' => 'Hazardous waste' },
        { 'code' => 'K-6', 'name' => 'Medical waste' },
        { 'code' => 'K-3', 'name' => 'Recycled waste' },
        { 'code' => 'L-1', 'name' => 'Childcare facility' },
        { 'code' => 'L-2', 'name' => 'Sports and leisure' },
        { 'code' => 'L-3', 'name' => 'Driver and vehicle service' },
        { 'code' => 'L-4', 'name' => 'First aid and medical service' },
        { 'code' => 'L-5', 'name' => 'Flag flying service' },
        { 'code' => 'L-6', 'name' => 'Journal, magazine and newspaper supply' },
        { 'code' => 'L-7', 'name' => 'Hairdressing services' },
        { 'code' => 'L-8', 'name' => 'Footwear cobbling services' },
        { 'code' => 'L-9', 'name' => 'Provision of chaplaincy support services' },
        { 'code' => 'L-10', 'name' => 'Housing and residential accommodation management' },
        { 'code' => 'L-11', 'name' => 'Training establishment management and booking service' },
        { 'code' => 'M-1', 'name' => 'CAFM system' },
        { 'code' => 'N-1', 'name' => 'Helpdesk services' },
        { 'code' => 'O-1', 'name' => 'Management of billable works' }
      ],
      fm_building_type: 'Residential Buildings' }
  end

  let(:building3) do
    { 'id' => '5D0901B0-E8C1-C6A7-191D-4710C4514EE1', 'gia' => 12345, 'name' => 'ccs', 'region' => 'London',
      'address' => { 'fm-address-town' => 'London', 'fm-address-line-1' => '151 Buckingham Palace Road', 'fm-address-postcode' => 'SW1W 9SZ' },
      'isLondon' => 'No',
      'services' => [
        { 'code' => 'C-21', 'name' => 'Airport and aerodrome maintenance services' },
        { 'code' => 'C-15', 'name' => 'Audio visual (AV) equipment maintenance' },
        { 'code' => 'C-10', 'name' => 'Automated barrier control system maintenance' },
        { 'code' => 'C-11', 'name' => 'Building management system (BMS) maintenance' },
        { 'code' => 'C-14', 'name' => 'Catering equipment maintenance' },
        { 'code' => 'C-3', 'name' => 'Environmental cleaning' },
        { 'code' => 'C-4', 'name' => 'Fire detection and firefighting systems maintenance' },
        { 'code' => 'C-13', 'name' => 'High voltage (HV) and switchgear maintenance' },
        { 'code' => 'C-7', 'name' => 'Internal and external building fabric maintenance' },
        { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
        { 'code' => 'C-20', 'name' => 'Locksmith services' },
        { 'code' => 'C-17', 'name' => 'Mail room equipment maintenance' },
        { 'code' => 'C-1', 'name' => 'Mechanical and electrical engineering maintenance' },
        { 'code' => 'C-18', 'name' => 'Office machinery servicing and maintenance' },
        { 'code' => 'C-9', 'name' => 'Planned / group re-lamping service' },
        { 'code' => 'C-8', 'name' => 'Reactive maintenance services' },
        { 'code' => 'C-6', 'name' => 'Security, access and intruder systems maintenance' },
        { 'code' => 'C-22', 'name' => 'Specialist maintenance services' },
        { 'code' => 'C-12', 'name' => 'Standby power system maintenance' },
        { 'code' => 'C-16', 'name' => 'Television cabling maintenance' },
        { 'code' => 'C-2', 'name' => 'Ventilation and air conditioning system maintenance' },
        { 'code' => 'C-19', 'name' => 'Voice announcement system maintenance' },
        { 'code' => 'D-6', 'name' => 'Cut flowers and christmas trees' },
        { 'code' => 'D-1', 'name' => 'Grounds maintenance services' },
        { 'code' => 'D-5', 'name' => 'Internal planting' },
        { 'code' => 'D-3', 'name' => 'Professional snow & ice clearance' },
        { 'code' => 'D-4', 'name' => 'Reservoirs, ponds, river walls and water features maintenance' },
        { 'code' => 'D-2', 'name' => 'Tree surgery (arboriculture)' },
        { 'code' => 'E-1', 'name' => 'Asbestos management' },
        { 'code' => 'E-9', 'name' => 'Building information modelling and government soft landings' },
        { 'code' => 'E-5', 'name' => 'Compliance plans, specialist surveys and audits' },
        { 'code' => 'E-6', 'name' => 'Conditions survey' },
        { 'code' => 'E-7', 'name' => 'Electrical testing' },
        { 'code' => 'E-8', 'name' => 'Fire risk assessments' },
        { 'code' => 'E-4', 'name' => 'Portable appliance testing' },
        { 'code' => 'E-3', 'name' => 'Statutory inspections' },
        { 'code' => 'E-2', 'name' => 'Water hygiene maintenance' },
        { 'code' => 'F-1', 'name' => 'Chilled potable water' },
        { 'code' => 'F-2', 'name' => 'Retail services / convenience store' },
        { 'code' => 'F-3', 'name' => 'Deli/coffee bar' },
        { 'code' => 'F-4', 'name' => 'Events and functions' },
        { 'code' => 'F-5', 'name' => 'Full service restaurant' },
        { 'code' => 'F-6', 'name' => 'Hospitality and meetings' },
        { 'code' => 'F-7', 'name' => 'Outside catering' },
        { 'code' => 'F-8', 'name' => 'Trolley service' },
        { 'code' => 'F-9', 'name' => 'Vending services (food & beverage)' },
        { 'code' => 'F-10', 'name' => 'Residential catering services' },
        { 'code' => 'G-8', 'name' => 'Cleaning of communications and equipment rooms' },
        { 'code' => 'G-13', 'name' => 'Cleaning of curtains and window blinds' },
        { 'code' => 'G-5', 'name' => 'Cleaning of external areas' },
        { 'code' => 'G-2', 'name' => 'Cleaning of integral barrier mats' },
        { 'code' => 'G-4', 'name' => 'Deep (periodic) cleaning' },
        { 'code' => 'G-10', 'name' => 'Housekeeping' },
        { 'code' => 'G-11', 'name' => 'It equipment cleaning' },
        { 'code' => 'G-16', 'name' => 'Linen and laundry services' },
        { 'code' => 'G-14', 'name' => 'Medical and clinical cleaning' },
        { 'code' => 'G-3', 'name' => 'Mobile cleaning services' },
        { 'code' => 'G-15', 'name' => 'Pest control services' },
        { 'code' => 'G-9', 'name' => 'Reactive cleaning (outside cleaning operational hours)' },
        { 'code' => 'G-1', 'name' => 'Routine cleaning' },
        { 'code' => 'G-12', 'name' => 'Specialist cleaning' },
        { 'code' => 'G-7', 'name' => 'Window cleaning (external)' },
        { 'code' => 'G-6', 'name' => 'Window cleaning (internal)' },
        { 'code' => 'H-16', 'name' => 'Administrative support services' },
        { 'code' => 'H-9', 'name' => 'Archiving (on-site)' },
        { 'code' => 'H-12', 'name' => 'Cable management' },
        { 'code' => 'H-7', 'name' => 'Clocks' },
        { 'code' => 'H-3', 'name' => 'Courier booking and external distribution' },
        { 'code' => 'H-10', 'name' => 'Furniture management' },
        { 'code' => 'H-4', 'name' => 'Handyman services' },
        { 'code' => 'H-2', 'name' => 'Internal messenger service' },
        { 'code' => 'H-1', 'name' => 'Mail services' },
        { 'code' => 'H-5', 'name' => 'Move and space management - internal moves' },
        { 'code' => 'H-15', 'name' => 'Portable washroom solutions' },
        { 'code' => 'H-6', 'name' => 'Porterage' },
        { 'code' => 'H-13', 'name' => 'Reprographics service' },
        { 'code' => 'H-8', 'name' => 'Signage' },
        { 'code' => 'H-11', 'name' => 'Space management' },
        { 'code' => 'H-14', 'name' => 'Stores management' },
        { 'code' => 'I-3', 'name' => 'Car park management and booking' },
        { 'code' => 'I-1', 'name' => 'Reception service' },
        { 'code' => 'I-2', 'name' => 'Taxi booking service' },
        { 'code' => 'I-4', 'name' => 'Voice announcement system operation' },
        { 'code' => 'J-8', 'name' => 'Additional security services' },
        { 'code' => 'J-2', 'name' => 'Cctv / alarm monitoring' },
        { 'code' => 'J-3', 'name' => 'Control of access and security passes' },
        { 'code' => 'J-4', 'name' => 'Emergency response' },
        { 'code' => 'J-9', 'name' => 'Enhanced security requirements' },
        { 'code' => 'J-10', 'name' => 'Key holding' },
        { 'code' => 'J-11', 'name' => 'Lock up / open up of buyer premises' },
        { 'code' => 'J-6', 'name' => 'Management of visitors and passes' },
        { 'code' => 'J-1', 'name' => 'Manned guarding service' },
        { 'code' => 'J-5', 'name' => 'Patrols (fixed or static guarding)' },
        { 'code' => 'J-12', 'name' => 'Patrols (mobile via a specific visiting vehicle)' },
        { 'code' => 'J-7', 'name' => 'Reactive guarding' },
        { 'code' => 'K-1', 'name' => 'Classified waste' },
        { 'code' => 'K-5', 'name' => 'Clinical waste' },
        { 'code' => 'K-7', 'name' => 'Feminine hygiene waste' },
        { 'code' => 'K-2', 'name' => 'General waste' },
        { 'code' => 'K-4', 'name' => 'Hazardous waste' },
        { 'code' => 'K-6', 'name' => 'Medical waste' },
        { 'code' => 'K-3', 'name' => 'Recycled waste' },
        { 'code' => 'L-1', 'name' => 'Childcare facility' },
        { 'code' => 'L-2', 'name' => 'Sports and leisure' },
        { 'code' => 'L-3', 'name' => 'Driver and vehicle service' },
        { 'code' => 'L-4', 'name' => 'First aid and medical service' },
        { 'code' => 'L-5', 'name' => 'Flag flying service' },
        { 'code' => 'L-6', 'name' => 'Journal, magazine and newspaper supply' },
        { 'code' => 'L-7', 'name' => 'Hairdressing services' },
        { 'code' => 'L-8', 'name' => 'Footwear cobbling services' },
        { 'code' => 'L-9', 'name' => 'Provision of chaplaincy support services' },
        { 'code' => 'L-10', 'name' => 'Housing and residential accommodation management' },
        { 'code' => 'L-11', 'name' => 'Training establishment management and booking service' },
        { 'code' => 'M-1', 'name' => 'CAFM system' },
        { 'code' => 'N-1', 'name' => 'Helpdesk services' },
        { 'code' => 'O-1', 'name' => 'Management of billable works' }
      ],
      fm_building_type: 'General office - Customer Facing' }
  end

  let(:buildings) do
    [
      OpenStruct.new(building_json: building1),
      OpenStruct.new(building_json: building2)
    ]
  end

  let(:buildings2) do
    [
      OpenStruct.new(building_json: building3)
    ]
  end

  let(:building3_services_for_procurement_1) do
  end

  let(:procurement_1) do
    OpenStruct.new(
      name: 'Procurement 1',
      buildings_and_services: [[building3, services: []]]
    )
  end

  it 'can model services' do
    FacilitiesManagement::Service.all.sort_by { |s| [s.work_package_code, s.code[s.code.index('.') + 1..-1].to_i] }.each do |service|
      # p service
    end
  end

  # rubocop:disable RSpec/ExampleLength
  it 'can calculate a direct award procurement' do
    p '*********'
    p CCS::FM::UnitsOfMeasurement.all.count
    p '*********'

    uoms = CCS::FM::UnitsOfMeasurement.all.group_by(&:service_usage)
    uom2 = {}
    uoms.map { |u| u[0].each { |k| uom2[k] = u[1] } }

    FacilitiesManagement::Service
      .all
      .sort_by { |s| [s.work_package_code, s.code[s.code.index('.') + 1..-1].to_i] }.each do |service|

      p service
      p '  has uom ' if uom2[service.code]
    end

    p FacilitiesManagement::Service.all.map(&:code)

    # ----------
    region_codes = Nuts3Region.all.map(&:code)

    p Nuts3Region.all.first.inspect
    p region_codes

    # ----------

    # input params
    vals = {}
    vals['tupe'] = 'no' # 'yes' : 'no',
    vals['contract-length'] = 3
    vals['gia'] = 12345
    vals['isLondon'] = true
    id = SecureRandom.uuid

    p 'procurement info'

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

    p 'Buildings info'
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

    p "There are #{uom2.count} services with a specific * units of measure *"
    p "There are #{Nuts3Region.all.count} NUTS3 regions"

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

    report = FacilitiesManagement::SummaryReport.new(start_date, 'test@example.com', procurement)

    results = {}
    supplier_names = rate_card.data['Prices'].keys
    supplier_names.each do |supplier_name|
      # dummy_supplier_name = 'Hickle-Schinner'
      results[supplier_name]  = {}
      report.calculate_services_for_buildings all_buildings, uom_vals, rates, rate_card, supplier_name, results[supplier_name]
      results[supplier_name][:direct_award_value] = report.direct_award_value
    end

    p report.direct_award_value
    expect(report.direct_award_value).to be > -1
  end
  # rubocop:enable RSpec/ExampleLength
end
