# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
#
## Supply teachers seeds

holborn = SupplyTeachers::Supplier.create!(name: 'Holborn')
holborn.branches.create!(
  postcode: 'WC2B 6TE',
  location: Geocoding.point(latitude: 51.5149666, longitude: -0.119098),
  contact_name: 'Lucija Bidzina',
  contact_email: 'lucija.bidzina@example.com',
  telephone_number: '03069 990000'
)
holborn.rates.create!(
  lot_number: 1,
  job_type: 'nominated',
  mark_up: 0.35
)
holborn.rates.create!(
  lot_number: 1,
  job_type: 'qt',
  term: 'one_week',
  mark_up: 0.40
)
holborn.rates.create!(
  lot_number: 1,
  job_type: 'qt',
  term: 'twelve_weeks',
  mark_up: 0.38
)

westminster = SupplyTeachers::Supplier.create!(name: 'Westminster')
westminster.branches.create!(
  postcode: 'W1A 1AA',
  name: 'Head office',
  location: Geocoding.point(latitude: 51.5185614, longitude: -0.1437991),
  contact_name: 'Hefina Neophytos',
  contact_email: 'hefina.neophytos@example.com',
  telephone_number: '03069 990001'
)
westminster.rates.create!(
  lot_number: 1,
  job_type: 'nominated',
  mark_up: 0.30
)
westminster.rates.create!(
  lot_number: 1,
  job_type: 'qt',
  term: 'one_week',
  mark_up: 0.42
)
westminster.rates.create!(
  lot_number: 1,
  job_type: 'qt',
  term: 'twelve_weeks',
  mark_up: 0.35
)

liverpool = SupplyTeachers::Supplier.create!(name: 'Liverpool')
liverpool.branches.create!(
  postcode: 'L3 9PP',
  name: 'North-West',
  location: Geocoding.point(latitude: 53.409189, longitude: -2.9946932),
  contact_name: 'Rona Severinus',
  contact_email: 'rona.severinus@example.com',
  telephone_number: '03069 990001'
)
liverpool.rates.create!(
  lot_number: 1,
  job_type: 'nominated',
  mark_up: 0.25
)
liverpool.rates.create!(
  lot_number: 1,
  job_type: 'qt',
  term: 'one_week',
  mark_up: 0.35
)
liverpool.rates.create!(
  lot_number: 1,
  job_type: 'qt',
  term: 'twelve_weeks',
  mark_up: 0.32
)

# Facilities Management seeds
# Seeds are created against the last user created in the database
# Creates a procurement in detailed_search state with all services
if ENV["fm"]
  user = User.last
  wk_codes = FacilitiesManagement::StaticData.services.map{|s| s['code']}
  services = FacilitiesManagement::StaticData.work_packages.select!{|wc| wc if wc['code'] != "G.1" && wk_codes.include?(wc['work_package_code'])}
  service_codes = services.map{|s| s['code']}

  procurement = FacilitiesManagement::Procurement.create!(
    user_id: user.id,
    aasm_state: "detailed_search",
    service_codes: service_codes,
    region_codes: ["UKC1"],
    contract_name: Faker::Name.unique.name + "'s Procurement",
    estimated_annual_cost: 34689000,
    tupe: true,
    initial_call_off_period: 2,
    initial_call_off_start_date: DateTime.now + 2.months,
    initial_call_off_end_date: nil,
    mobilisation_period: 4,
    optional_call_off_extensions_1: 2,
    optional_call_off_extensions_2: 2,
    estimated_cost_known: true,
    mobilisation_period_required: true,
    extensions_required: true,
    da_journey_state: "pricing")

  # creates 1000 buildings
  (0..999).each do |index|
    postcode = 'WC2A 1AA'
    street_address = '75 Chancery Lane'
    town = 'London'
    building = FacilitiesManagement::Building.create!(user: user,
                                                     user_email: user.email,
                                                     building_name: Faker::Name.unique.name + "'s Building",
                                                     address_line_1: street_address,
                                                     address_town: town,
                                                     address_postcode: postcode,
                                                     external_area: rand(200..4000),
                                                     gia: rand(200..4000),
                                                     building_type: 'General office - Customer Facing',
                                                     security_type: 'Baseline personnel security standard (BPSS)')
    region = Postcode::PostcodeCheckerV2.find_region postcode.delete(' ')
    building.address_region_code = region[0]['code']
    building.address_region = region[0]['region']
    building.populate_json_attribute
    building.save
    procurement_building = FacilitiesManagement::ProcurementBuilding.create!(
      procurement: procurement,
      building_id: building.id,
      service_codes: service_codes,
      active: true)
    procurement_building.procurement_building_services.each do |pbs|
      pbs.update(
        service_standard: 'A',
        no_of_appliances_for_testing: rand(200..2000),
        no_of_building_occupants: rand(200..2000),
        no_of_consoles_to_be_serviced: rand(200..2000),
        tones_to_be_collected_and_removed: rand(200..2000),
        no_of_units_to_be_serviced: rand(200..2000),
        lift_data: ["25", "12", "64"],
        service_hours: rand(200..2000),
        detail_of_requirement: 'test'
      )
    end
    puts "Building ##{index} created"
  end
end