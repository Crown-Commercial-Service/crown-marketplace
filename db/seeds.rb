# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

point_factory = RGeo::Geographic.spherical_factory(srid: 4326)

holborn = Supplier.create!(name: 'Holborn')
holborn.branches.create!(postcode: 'WC2B 6TE', location: point_factory.point(-0.119098, 51.5149666))

westminster = Supplier.create!(name: 'Westminster')
westminster.branches.create!(postcode: 'W1A 1AA', location: point_factory.point(-0.1437991, 51.5185614))

liverpool = Supplier.create!(name: 'Liverpool')
liverpool.branches.create!(postcode: 'L3 9PP', location: point_factory.point(-2.9946932,53.409189))
