module FM
  require 'pg'
  require 'json'
  require Rails.root.join('lib', 'tasks', 'distributed_locks')

  def self.create_uom_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DROP TABLE IF EXISTS public.facilities_management_rm3830_units_of_measurements; CREATE TABLE public.facilities_management_rm3830_units_of_measurements (
	id serial NOT NULL,
	title_text varchar NOT NULL,
	example_text varchar NULL,
	unit_text varchar NULL,
  data_type varchar NULL,
  spreadsheet_label varchar NULL,
  unit_measure_label varchar NULL,
	service_usage text[] NULL
);
-- TRUNCATE TABLE public.facilities_management_rm3830_units_of_measurements;
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(3, 'What''s the number of floors each lift can access?', 'For example, 10. A lift going up between floor 6 and floor 16, gives a total of 10 floors', '', 'numeric', 'The sum total of number of floors per lift', 'price per Number (per lift per floor)', '{C.5}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(4, 'How many appliances do you have for testing each year?', 'For example, 150. When 100 PC computers, 50 laptops needs PAT service each year', 'units (each year)', 'numeric', 'Number of appliances in the building to be tested per annum', 'price per Number (per unit)', '{E.4}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(5, 'What''s the number of building users (occupants) in this building?', 'For example, 56. What''s the maximum capacity of this building.', 'occupants (each year)', 'numeric', 'Number of Building Users (Occupants)', 'price per Square Metre (GIA)', '{G.1,G.3}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(6, 'What''s the total external area of this building?', 'For example, 21000 sqm. When the total external area measures 21000 sqm', 'sqm (square metres)', 'numeric', 'Square Metre (GIA) per annum', 'price per Square Metre (external area)', '{G.5}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(8, 'How many tonnes of waste need disposal each year?', 'Number of tonnes per annum', 'tonnes (each year)', 'numeric', 'Number of tonnes per annum', 'price per tonne', '{K.2,K.3}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(7, 'How many hours are required each year?', 'Example, 520. If this service is required for 10 hours per week, then enter 520 hours (each year)', '', 'numeric', 'Number of hours required per annum', 'hourly rate', '{H.4,H.5,I.1,I.2,I.3,I.4,J.1,J.2,J.3,J.4,J.5,J.6}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(9, 'How many classified waste consoles need emptying each year?', 'Example 60. When 5 consoles are emptied monthly, enter 60 consoles each year', 'units (each year)', 'numeric', 'Number of consoles per annum', 'price per console', '{K.1}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(10, 'How many units of feminine hygiene waste need to be emptied each year?', 'Example, 600. When 50 units per month need emptying, enter 600 units each year', 'units (each year)', 'numeric', 'Number of units per annum', 'price per unit', '{K.7}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(11, 'help,cafm', 'Example, help,cafm', 'units (each year)', 'numeric', 'Percentage of Year 1 Deliverables Value (excluding Management and Corporate Overhead, and Profit) at call-off.', 'per % of Year 1 Deliverables Value', '{N.1,M.1}');
INSERT INTO public.facilities_management_rm3830_units_of_measurements (id, title_text, example_text, unit_text, data_type, spreadsheet_label, unit_measure_label, service_usage) VALUES(12, 'what''s the number of square metres?', 'Example, 1000 sqm', 'sqm (square metres)', 'numeric', 'Square Metre (GIA) per annum', 'price per Square Metre (GIA)', '{C.1,C.2,C.3,C.4,C.6,C.7,C.11,C.12,C.13,E.1,E.2,E.3,E.5,E.6,E.7,E.8,G.1,G.2,G.4,G.6,G.7,G.15}');"
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.static_data_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'DROP TABLE if exists public.facilities_management_rm3830_static_data; CREATE TABLE if not exists public.facilities_management_rm3830_static_data ("key" varchar NOT NULL, value jsonb NULL);'
      db.query query
      query = 'truncate table public.facilities_management_rm3830_static_data; CREATE INDEX facilities_management_rm3830_static_data_key_idx ON public.facilities_management_rm3830_static_data USING btree (key);'
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.facilities_management_services
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DELETE FROM facilities_management_rm3830_static_data WHERE key = 'services';"
      db.query query
      query = "INSERT INTO public.facilities_management_rm3830_static_data (key, value) VALUES('services', '[{\"code\": \"C\", \"name\": \"Maintenance services\"}, {\"code\": \"D\", \"name\": \"Horticultural services\"}, {\"code\": \"E\", \"name\": \"Statutory obligations\"}, {\"code\": \"F\", \"name\": \"Catering services\"}, {\"code\": \"G\", \"name\": \"Cleaning services\"}, {\"code\": \"H\", \"name\": \"Workplace FM services\"}, {\"code\": \"I\", \"name\": \"Reception services\"}, {\"code\": \"J\", \"name\": \"Security services\"}, {\"code\": \"K\", \"name\": \"Waste services\"}, {\"code\": \"L\", \"name\": \"Miscellaneous FM services\"}, {\"code\": \"M\", \"name\": \"Computer-aided facilities management (CAFM)\"}, {\"code\": \"N\", \"name\": \"Helpdesk services\"}, {\"code\": \"O\", \"name\": \"Management of billable works\"}]');"
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.facilities_management_work_packages
    data = File.read('data/facilities_management/rm3830/work_packages.json').delete!("\n")

    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DELETE FROM facilities_management_rm3830_static_data WHERE key = 'work_packages';"
      db.query query
      query = "INSERT INTO public.facilities_management_rm3830_static_data (key, value) VALUES('work_packages', '#{data}' );"
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.facilities_management_bank_holidays
    data = File.read('data/facilities_management/rm3830/bank_holidays.json').delete!("\n")

    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "DELETE FROM facilities_management_rm3830_static_data WHERE key = 'bank_holidays';"
      db.query query
      query = "INSERT INTO public.facilities_management_rm3830_static_data (key, value) VALUES('bank_holidays', '#{data}' );"
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end
end

namespace :db do
  namespace :rm3830 do
    desc 'add FM static data to the database'
    task fmdata: :environment do
      DistributedLocks.distributed_lock(153) do
        puts 'Creating FM UOM table'
        FM.create_uom_table
        puts 'Creating FM static data table'
        FM.static_data_table
        puts 'add services data to fm_static_table'
        FM.facilities_management_services
        puts 'add work_packages data to fm_static_table'
        FM.facilities_management_work_packages
        puts 'add bank_holidays data to fm_static_table'
        FM.facilities_management_bank_holidays
      end
    end
  end

  desc 'add FM static data to the database'
  task static: :'rm3830:fmdata'
end
