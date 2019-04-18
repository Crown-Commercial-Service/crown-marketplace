module FM
  require 'pg'
  require 'json'

  def self.create_uom_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = "CREATE TABLE IF NOT EXISTS public.fm_units_of_measurement (
	id serial NOT NULL,
	title_text varchar NOT NULL,
	example_text varchar NULL,
	unit_text varchar NULL,
	data_type varchar NULL,
	service_usage text[] NULL
);
TRUNCATE TABLE public.fm_units_of_measurement;
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(2, 'How many lifts do you have in this building?', 'For example, 5', '', 'numeric', '{C.5}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(3, 'What''s the number of floors each lift can access?', 'For example, 10. A lift going up between floor 6 and floor 16, gives a total of 10 floors', '', 'numeric', '{C.5}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(4, 'How many appliances do you have for testing each year?', 'For example, 150. When 100 PC computers, 50 laptops needs PAT service each year', 'units (each year)', 'numeric', '{E.4}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(5, 'What''s the number of building users (occupants) in this building?', 'For example, 56. What''s the maximum capacity of this building.', 'occupants (each year)', 'numeric', '{G.1,G.3}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(6, 'What''s the total external area of this building?', 'For example, 21000 sqm. When thte total external area measures 21000 sqm', 'sqm (square metres)', 'numeric', '{G.5}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(7, 'How many hours are required each year?', 'Example, 520. If this service is required fro 10 hours per wek, then enter 520 hours per year', '', 'numeric', '{H.4,H.5,I.1,I.2,I.3,I.4,J.1,J.2,J.3,J.4,J.5,J.6}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(8, 'How many tonnes of waste need disposal each year?', 'Example, 100', 'tonnes (each year)', 'numeric', '{K.2,K.3,K.4,K.5,K.6}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(9, 'How many classified waste consoles need emptying each year?', 'Example 5. When 5 consoles are emptied each month, enter 60 consoles per year', 'units (each year)', 'numeric', '{K.1}');
INSERT INTO public.fm_units_of_measurement (id, title_text, example_text, unit_text, data_type, service_usage) VALUES(10, 'How many units of feminine hygiene waste need to be emptied each year?', 'Example, 500. When 50 units per month need emptying, enter 600 units per year', 'units (each year)', 'numeric', '{K.7}'); "
      db.query query
    end
  rescue PG::Error => e
    puts e.message
  end
end
namespace :db do
  desc 'add FM static data to the database'
  task static: :environment do
    p 'Creating UOM Table'
    FM.create_uom_table
  end
  desc 'add FM static data to the database'
  task setup: :static do
  end
end
