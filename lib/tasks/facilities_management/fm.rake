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
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, spreadsheet_label, service_usage) VALUES(10, 'How many units of feminine hygiene waste need to be emptied each year?', 'Example, 600. When 50 units per month need emptying, enter 600 units each year', 'units (each year)', 'numeric', 'Number of units per annum', '{K.7}');"
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
      query = "create table if not exists fm_lifts (user_id varchar not null, building_id varchar not null, lift_data jsonb not null); drop index if exists fm_lifts_user_id_idx; create index fm_lifts_user_id_idx on fm_lifts using btree (user_id, building_id); drop index if exists fm_lifts_lift_json; create index fm_lifts_lift_json on fm_lifts using GIN ((lift_data -> 'floor-data'));"
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
      query = "INSERT INTO public.fm_static_data (key, value) VALUES('services', " + '\'[{"code": "C", "name": "Maintenance services"}, {"code": "D", "name": "Horticultural services"}, {"code": "E", "name": "Statutory obligations"}, {"code": "F", "name": "Catering services"}, {"code": "G", "name": "Cleaning services"}, {"code": "H", "name": "Workplace FM services"}, {"code": "I", "name": "Reception services"}, {"code": "J", "name": "Security services"}, {"code": "K", "name": "Waste services"}, {"code": "L", "name": "Miscellaneous FM services"}, {"code": "M", "name": "Computer-aided facilities management (CAFM)"}, {"code": "N", "name": "Helpdesk services"}]\');'
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

  def self.work_packages
    data = File.read 'data/facilities_management/work_packages.json'
    data.delete!("\n")
  end

  def self.facilities_management_work_packages
    data = work_packages

    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DELETE FROM fm_static_data WHERE key = 'work_packages';"
      db.query query
      query = "INSERT INTO public.fm_static_data (key, value) VALUES('work_packages', \'" + data + "\' );"
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
