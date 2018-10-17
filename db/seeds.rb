# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

holborn = Supplier.create!(name: 'Holborn')
holborn.branches.create!(
  postcode: 'WC2B 6TE',
  location: Geocoding.point(latitude: 51.5149666, longitude: -0.119098),
  contact_name: 'Lucija Bidzina',
  contact_email: 'lucija.bidzina@example.com',
  telephone_number: '03069 990000'
)
holborn.rates.create!(
  job_type: 'nominated',
  mark_up: 0.35
)

westminster = Supplier.create!(name: 'Westminster')
westminster.branches.create!(
  postcode: 'W1A 1AA',
  name: 'Head office',
  location: Geocoding.point(latitude: 51.5185614, longitude: -0.1437991),
  contact_name: 'Hefina Neophytos',
  contact_email: 'hefina.neophytos@example.com',
  telephone_number: '03069 990001'
)
westminster.rates.create!(
  job_type: 'nominated',
  mark_up: 0.30
)

liverpool = Supplier.create!(name: 'Liverpool')
liverpool.branches.create!(
  postcode: 'L3 9PP',
  name: 'North-West',
  location: Geocoding.point(latitude: 53.409189, longitude: -2.9946932),
  contact_name: 'Rona Severinus',
  contact_email: 'rona.severinus@example.com',
  telephone_number: '03069 990001'
)
liverpool.rates.create!(
  job_type: 'nominated',
  mark_up: 0.25
)
