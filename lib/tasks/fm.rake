module FM
  require 'pg'
  require 'json'
  require './lib/tasks/distributed_locks'

  def self.create_uom_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DROP TABLE IF EXISTS public.fm_units_of_measurement; CREATE TABLE public.fm_units_of_measurement (
	id serial NOT NULL,
	title_text varchar NOT NULL,
	example_text varchar NULL,
	unit_text varchar NULL,
  data_type varchar NULL,
  spreadsheet_label varchar NULL,
	service_usage text[] NULL
);
-- TRUNCATE TABLE public.fm_units_of_measurement;
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(2, 'How many lifts do you have in this building?', 'For example, 5', '', 'numeric', '', '{C.5}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(3, 'What''s the number of floors each lift can access?', 'For example, 10. A lift going up between floor 6 and floor 16, gives a total of 10 floors', '', 'numeric', 'The sum total of number of floors per lift', '{C.5}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(4, 'How many appliances do you have for testing each year?', 'For example, 150. When 100 PC computers, 50 laptops needs PAT service each year', 'units (each year)', 'numeric', 'Number of appliances in the building to be tested per annum', '{E.4}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(5, 'What''s the number of building users (occupants) in this building?', 'For example, 56. What''s the maximum capacity of this building.', 'occupants (each year)', 'numeric', 'Number of Building Users (Occupants)', '{G.1,G.3}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(6, 'What''s the total external area of this building?', 'For example, 21000 sqm. When the total external area measures 21000 sqm', 'sqm (square metres)', 'numeric', 'Square Metre (GIA) per annum', '{G.5}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(8, 'How many tonnes of waste need disposal each year?', 'Number of tonnes per annum', 'tonnes (each year)', 'numeric', 'Number of tonnes per annum', '{K.2,K.3}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(7, 'How many hours are required each year?', 'Example, 520. If this service is required for 10 hours per week, then enter 520 hours (each year)', '', 'numeric', 'Number of hours required per annum', '{H.4,H.5,I.1,I.2,I.3,I.4,J.1,J.2,J.3,J.4,J.5,J.6}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(9, 'How many classified waste consoles need emptying each year?', 'Example 60. When 5 consoles are emptied monthly, enter 60 consoles each year', 'units (each year)', 'numeric', 'Number of consoles per annum', '{K.1}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(10, 'How many units of feminine hygiene waste need to be emptied each year?', 'Example, 600. When 50 units per month need emptying, enter 600 units each year', 'units (each year)', 'numeric', 'Number of units per annum', '{K.7}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(11, '', '', '', '', 'Percentage of Year 1 Deliverables Value (excluding Management and Corporate Overhead, and Profit) at call-off.', '{M.1,N.1}');"
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.create_uom_values_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'CREATE TABLE IF NOT EXISTS public.fm_uom_values (
	user_id varchar NULL,
	service_code varchar NULL,
	uom_value varchar NULL,
	building_id varchar NULL
);
DROP INDEX IF EXISTS fm_uom_values_user_id_idx; CREATE INDEX fm_uom_values_user_id_idx ON public.fm_uom_values USING btree (user_id, service_code, building_id);
'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.create_fm_lifts_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "create table if not exists fm_lifts (user_id varchar not null, building_id varchar not null, lift_data jsonb not null); drop index if exists fm_lifts_user_id_idx; create index fm_lifts_user_id_idx on fm_lifts using btree (user_id, building_id); drop index if exists fm_lifts_lift_json; create index if not exists fm_lifts_lift_json on fm_lifts using GIN ((lift_data -> 'floor-data'));"
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.facilities_management_buildings
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "create table if not exists facilities_management_buildings (user_id varchar not null, building_json jsonb not null); DROP INDEX IF EXISTS idx_buildings_gin; CREATE INDEX idx_buildings_gin ON facilities_management_buildings USING GIN (building_json); DROP INDEX IF EXISTS idx_buildings_ginp; CREATE INDEX idx_buildings_ginp ON facilities_management_buildings USING GIN (building_json jsonb_path_ops); DROP INDEX IF EXISTS idx_buildings_service; CREATE INDEX idx_buildings_service ON facilities_management_buildings USING GIN ((building_json -> 'services'));DROP INDEX IF EXISTS idx_buildings_user_id; CREATE INDEX idx_buildings_user_id ON facilities_management_buildings USING btree (user_id);"
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.truncate_buildings_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'TRUNCATE TABLE public.facilities_management_buildings;'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.facilities_management_services
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DELETE FROM fm_static_data WHERE key = 'services';"
      db.query query
      query = "INSERT INTO public.fm_static_data (key, value) VALUES('services', " + '\'[{"code": "C", "name": "Maintenance services"}, {"code": "D", "name": "Horticultural services"}, {"code": "E", "name": "Statutory obligations"}, {"code": "F", "name": "Catering services"}, {"code": "G", "name": "Cleaning services"}, {"code": "H", "name": "Workplace FM services"}, {"code": "I", "name": "Reception services"}, {"code": "J", "name": "Security services"}, {"code": "K", "name": "Waste services"}, {"code": "L", "name": "Miscellaneous FM services"}, {"code": "M", "name": "Computer-aided facilities management (CAFM)"}, {"code": "N", "name": "Helpdesk services"}, {"code": "O", "name": "Management of billable works"}]\');'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.static_data_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'DROP TABLE if exists public.fm_static_data; CREATE TABLE if not exists public.fm_static_data ("key" varchar NOT NULL, value jsonb NULL);'
      db.query query
      query = 'truncate table public.fm_static_data; CREATE INDEX fm_static_data_key_idx ON public.fm_static_data USING btree (key);'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.facilities_management_work_packages
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DELETE FROM fm_static_data WHERE key = 'work_packages';"
      db.query query
      query = "INSERT INTO public.fm_static_data (key, value) VALUES('work_packages', " + '\'[{"code": "A.7", "name": "Accessibility services", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.12", "name": "Business continuity and disaster recovery (“BCDR”) plans", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.9", "name": "Customer satisfaction", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.5", "name": "Fire safety", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.2", "name": "Health and safety", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.1", "name": "Integration", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.3", "name": "Management services", "mandatory": false, "unit_text": "", "work_package_code": "A"}, {"code": "A.11", "name": "Performance self-monitoring", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.6", "name": "Permit to work", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.16", "name": "Property information mapping service (EPIMS)", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.13", "name": "Quality management system", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.10", "name": "Reporting", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.8", "name": "Risk management", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.15", "name": "Selection and management of sub-contractors", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.4", "name": "Service delivery plans", "mandatory": false, "unit_text": "", "work_package_code": "A"}, {"code": "A.18", "name": "Social value", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.14", "name": "Staff and training", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "A.17", "name": "Sustainability", "mandatory": true, "unit_text": "", "work_package_code": "A"}, {"code": "B.1", "name": "Contract mobilisation", "mandatory": true, "unit_text": "", "work_package_code": "B"}, {"code": "C.21", "name": "Airport and aerodrome maintenance services", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.15", "name": "Audio visual (AV) equipment maintenance", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.10", "name": "Automated barrier control system maintenance", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.11", "name": "Building management system (BMS) maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.14", "name": "Catering equipment maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.3", "name": "Environmental cleaning", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.4", "name": "Fire detection and firefighting systems maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.13", "name": "High voltage (HV) and switchgear maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.7", "name": "Internal and external building fabric maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.5", "name": "Lifts, hoists and conveyance systems maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.20", "name": "Locksmith services", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.17", "name": "Mail room equipment maintenance", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.1", "name": "Mechanical and electrical engineering maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.18", "name": "Office machinery servicing and maintenance", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.9", "name": "Planned / group re-lamping service", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.8", "name": "Reactive maintenance services", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.6", "name": "Security, access and intruder systems maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.22", "name": "Specialist maintenance services", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.12", "name": "Standby power system maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.16", "name": "Television cabling maintenance", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "C.2", "name": "Ventilation and air conditioning system maintenance", "mandatory": true, "unit_text": "", "work_package_code": "C"}, {"code": "C.19", "name": "Voice announcement system maintenance", "mandatory": false, "unit_text": "", "work_package_code": "C"}, {"code": "D.6", "name": "Cut flowers and christmas trees", "mandatory": false, "unit_text": "", "work_package_code": "D"}, {"code": "D.1", "name": "Grounds maintenance services", "mandatory": false, "unit_text": "", "work_package_code": "D"}, {"code": "D.5", "name": "Internal planting", "mandatory": false, "unit_text": "", "work_package_code": "D"}, {"code": "D.3", "name": "Professional snow & ice clearance", "mandatory": false, "unit_text": "", "work_package_code": "D"}, {"code": "D.4", "name": "Reservoirs, ponds, river walls and water features maintenance", "mandatory": false, "unit_text": "", "work_package_code": "D"}, {"code": "D.2", "name": "Tree surgery (arboriculture)", "mandatory": false, "unit_text": "", "work_package_code": "D"}, {"code": "E.1", "name": "Asbestos management", "mandatory": true, "unit_text": "", "work_package_code": "E"}, {"code": "E.9", "name": "Building information modelling and government soft landings", "mandatory": false, "unit_text": "", "work_package_code": "E"}, {"code": "E.5", "name": "Compliance plans, specialist surveys and audits", "mandatory": true, "unit_text": "", "work_package_code": "E"}, {"code": "E.6", "name": "Conditions survey", "mandatory": false, "unit_text": "", "work_package_code": "E"}, {"code": "E.7", "name": "Electrical testing", "mandatory": true, "unit_text": "", "work_package_code": "E"}, {"code": "E.8", "name": "Fire risk assessments", "mandatory": true, "unit_text": "", "work_package_code": "E"}, {"code": "E.4", "name": "Portable appliance testing", "mandatory": true, "unit_text": "units (each year)", "work_package_code": "E"}, {"code": "E.3", "name": "Statutory inspections", "mandatory": true, "unit_text": "", "work_package_code": "E"}, {"code": "E.2", "name": "Water hygiene maintenance", "mandatory": true, "unit_text": "", "work_package_code": "E"}, {"code": "F.1", "name": "Chilled potable water", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.2", "name": "Retail services / convenience store", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.3", "name": "Deli/coffee bar", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.4", "name": "Events and functions", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.5", "name": "Full service restaurant", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.6", "name": "Hospitality and meetings", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.7", "name": "Outside catering", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.8", "name": "Trolley service", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.9", "name": "Vending services (food & beverage)", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "F.10", "name": "Residential catering services", "mandatory": false, "unit_text": "", "work_package_code": "F"}, {"code": "G.8", "name": "Cleaning of communications and equipment rooms", "mandatory": false, "unit_text": "", "work_package_code": "G"}, {"code": "G.13", "name": "Cleaning of curtains and window blinds", "mandatory": false, "unit_text": "occupants (each year)", "work_package_code": "G"}, {"code": "G.5", "name": "Cleaning of external areas", "mandatory": true, "unit_text": "sqm (square metres)", "work_package_code": "G"}, {"code": "G.2", "name": "Cleaning of integral barrier mats", "mandatory": true, "unit_text": "", "work_package_code": "G"}, {"code": "G.4", "name": "Deep (periodic) cleaning", "mandatory": true, "unit_text": "", "work_package_code": "G"}, {"code": "G.10", "name": "Housekeeping", "mandatory": false, "unit_text": "", "work_package_code": "G"}, {"code": "G.11", "name": "It equipment cleaning", "mandatory": false, "unit_text": "", "work_package_code": "G"}, {"code": "G.16", "name": "Linen and laundry services", "mandatory": false, "unit_text": "", "work_package_code": "G"}, {"code": "G.14", "name": "Medical and clinical cleaning", "mandatory": false, "unit_text": "", "work_package_code": "G"}, {"code": "G.3", "name": "Mobile cleaning services", "mandatory": true, "unit_text": "occupants (each year)", "work_package_code": "G"}, {"code": "G.15", "name": "Pest control services", "mandatory": true, "unit_text": "", "work_package_code": "G"}, {"code": "G.9", "name": "Reactive cleaning (outside cleaning operational hours)", "mandatory": true, "unit_text": "", "work_package_code": "G"}, {"code": "G.1", "name": "Routine cleaning", "mandatory": true, "unit_text": "", "work_package_code": "G"}, {"code": "G.12", "name": "Specialist cleaning", "mandatory": false, "unit_text": "", "work_package_code": "G"}, {"code": "G.7", "name": "Window cleaning (external)", "mandatory": true, "unit_text": "", "work_package_code": "G"}, {"code": "G.6", "name": "Window cleaning (internal)", "mandatory": true, "unit_text": "", "work_package_code": "G"}, {"code": "H.16", "name": "Administrative support services", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "H.9", "name": "Archiving (on-site)", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "H.12", "name": "Cable management", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "H.7", "name": "Clocks", "mandatory": true, "unit_text": "", "work_package_code": "H"}, {"code": "H.3", "name": "Courier booking and external distribution", "mandatory": true, "unit_text": "", "work_package_code": "H"}, {"code": "H.10", "name": "Furniture management", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "H.4", "name": "Handyman services", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "H"}, {"code": "H.2", "name": "Internal messenger service", "mandatory": true, "unit_text": "", "work_package_code": "H"}, {"code": "H.1", "name": "Mail services", "mandatory": true, "unit_text": "", "work_package_code": "H"}, {"code": "H.5", "name": "Move and space management - internal moves", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "H"}, {"code": "H.15", "name": "Portable washroom solutions", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "H.6", "name": "Porterage", "mandatory": true, "unit_text": "", "work_package_code": "H"}, {"code": "H.13", "name": "Reprographics service", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "H.8", "name": "Signage", "mandatory": true, "unit_text": "", "work_package_code": "H"}, {"code": "H.11", "name": "Space management", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "H.14", "name": "Stores management", "mandatory": false, "unit_text": "", "work_package_code": "H"}, {"code": "I.3", "name": "Car park management and booking", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "I"}, {"code": "I.1", "name": "Reception service", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "I"}, {"code": "I.2", "name": "Taxi booking service", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "I"}, {"code": "I.4", "name": "Voice announcement system operation", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "I"}, {"code": "J.8", "name": "Additional security services", "mandatory": false, "unit_text": "", "work_package_code": "J"}, {"code": "J.2", "name": "Cctv / alarm monitoring", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "J"}, {"code": "J.3", "name": "Control of access and security passes", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "J"}, {"code": "J.4", "name": "Emergency response", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "J"}, {"code": "J.9", "name": "Enhanced security requirements", "mandatory": false, "unit_text": "", "work_package_code": "J"}, {"code": "J.10", "name": "Key holding", "mandatory": false, "unit_text": "hours (each year)", "work_package_code": "J"}, {"code": "J.11", "name": "Lock up / open up of buyer premises", "mandatory": false, "unit_text": "", "work_package_code": "J"}, {"code": "J.6", "name": "Management of visitors and passes", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "J"}, {"code": "J.1", "name": "Manned guarding service", "mandatory": true, "unit_text": "", "work_package_code": "J"}, {"code": "J.5", "name": "Patrols (fixed or static guarding)", "mandatory": true, "unit_text": "hours (each year)", "work_package_code": "J"}, {"code": "J.12", "name": "Patrols (mobile via a specific visiting vehicle)", "mandatory": false, "unit_text": "", "work_package_code": "J"}, {"code": "J.7", "name": "Reactive guarding", "mandatory": true, "unit_text": "", "work_package_code": "J"}, {"code": "K.1", "name": "Classified waste", "mandatory": true, "unit_text": "units (each year)", "work_package_code": "K"}, {"code": "K.5", "name": "Clinical waste", "mandatory": false, "unit_text": "tonnes (each year)", "work_package_code": "K"}, {"code": "K.7", "name": "Feminine hygiene waste", "mandatory": true, "unit_text": "units (each year)", "work_package_code": "K"}, {"code": "K.2", "name": "General waste", "mandatory": true, "unit_text": "tonnes (each year)", "work_package_code": "K"}, {"code": "K.4", "name": "Hazardous waste", "mandatory": false, "unit_text": "tonnes (each year)", "work_package_code": "K"}, {"code": "K.6", "name": "Medical waste", "mandatory": false, "unit_text": "tonnes (each year)", "work_package_code": "K"}, {"code": "K.3", "name": "Recycled waste", "mandatory": true, "unit_text": "tonnes (each year)", "work_package_code": "K"}, {"code": "L.1", "name": "Childcare facility", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.2", "name": "Sports and leisure", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.3", "name": "Driver and vehicle service", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.4", "name": "First aid and medical service", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.5", "name": "Flag flying service", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.6", "name": "Journal, magazine and newspaper supply", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.7", "name": "Hairdressing services", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.8", "name": "Footwear cobbling services", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.9", "name": "Provision of chaplaincy support services", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.10", "name": "Housing and residential accommodation management", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "L.11", "name": "Training establishment management and booking service", "mandatory": false, "unit_text": "", "work_package_code": "L"}, {"code": "M.1", "name": "CAFM system", "mandatory": true, "unit_text": "", "work_package_code": "M"}, {"code": "N.1", "name": "Helpdesk services", "mandatory": true, "unit_text": "", "work_package_code": "N"}, {"code": "O.1", "name": "Management of billable works", "mandatory": true, "unit_text": "", "work_package_code": "O"}]\');'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end
end

namespace :db do
  desc 'add FM static data to the database'
  task fmdata: :environment do
    DistributedLocks.distributed_lock(153) do
      p 'Creating FM building database'
      FM.facilities_management_buildings
      p 'Creating FM UOM table'
      FM.create_uom_table
      p 'Creating FM UOM values table'
      FM.create_uom_values_table
      p 'Creating FM lift table'
      FM.create_fm_lifts_table
      p 'Creating FM static data table'
      FM.static_data_table
      p 'add services data to fm_static_table'
      FM.facilities_management_services
      p 'add work_packages data to fm_static_table'
      FM.facilities_management_work_packages
    end
  end
  desc 'add FM static data to the database'
  task static: :fmdata do
  end
end
