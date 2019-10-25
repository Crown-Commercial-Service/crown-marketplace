module CCS
  require 'pg'
  require 'csv'
  require 'json'
  require './lib/tasks/distributed_locks'

  def self.csv_to_nuts_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS nuts_regions (code varchar(255) UNIQUE, name varchar(255),
      nuts1_code varchar(255), nuts2_code varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM nuts_regions where code = '" + row['code'] + "' ; ")
        db.exec_query('insert into nuts_regions ( ' + column_names + ') values (' + values + ')')
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.csv_to_fm_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS fm_regions (code varchar(255) UNIQUE, name varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM fm_regions where code = '" + row['code'] + "' ; ")
        db.exec_query('insert into fm_regions ( ' + column_names + ') values (' + values + ')')
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.csv_to_fm_rates(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'create table IF NOT EXISTS fm_rates (code varchar(255) UNIQUE, framework numeric, benchmark numeric );
      TRUNCATE TABLE fm_rates;'
      db.query query
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        query = "DELETE FROM fm_rates where code = '" + row['code'] + "' ; " \
                'insert into fm_rates ( ' + column_names + ') values (' + values + ')'
        db.query query
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.populate_security_types
    ActiveRecord::Base.connection_pool.with_connection do |db|
      insert_query = %(DELETE from fm_security_types; INSERT INTO fm_security_types (id,title,description,sort_order) VALUES
('82172139-3ade-4cf1-9d62-babf9d8c1fdd','Baseline personnel security standard (BPSS)','generally used as pre-employment checks. Ascertains the
trustworthiness and reliability of a prospective candidate, looking at
Identity, Employment history, Nationality and immigration status, and
Criminal record',1)
,('592c3fdf-d5a2-4283-a965-5a24c4ae507a','Counter terrorist check (CTC)','is carried out if an individual is working in proximity to public figures, or
requires unescorted access to certain military, civil, industrial or
commercial establishments assessed to be at particular risk from
terrorist attack',2)
,('b0b20156-3a2e-48aa-aaa2-3772b6cec0c3','Security check (SC)','determines that a person’s character and personal circumstances are
such that they can be trusted to work in a position which involves longterm, frequent and uncontrolled access to SECRET assets',3)
,('df8527b6-8257-462a-b093-2fbaca370d80','Developed vetting (DV)','in addition to SC, this detailed check is appropriate when an individual
has long term, frequent and uncontrolled access to ‘Top Secret’
information. There is also Enhanced DV',4)
,('e218afcd-0ac7-46e4-8b23-f0e822c662a3','Basic DBS','for any purpose, including employment. The certificate will contain
details of convictions and conditional cautions that are considered to be
unspent',5)
,('671ba66f-9f40-41c4-bfb4-9bafe2574c67','Standard DBS','contains details of both spent and unspent convictions, cautions,
reprimands and warnings that are held on the Police National Computer',6)
,('0fd4ac35-c6d3-41c0-a8be-edce11242b4f','Enhanced DBS','as per the Standard DBS, plus also searches the DBS Barred Lists, inc the
Children’s Barred List',7)
,('b9e6a0de-f698-4490-8372-17d368fc94a7','Disclosure Scotland Basic','a criminal record check, containing unspent criminal convictions',8)
,('756bef4b-dfff-4ba1-bec3-b269b0b8fc9a','Disclosure Scotland Standard','contains information on convictions and cautions, information from Sex
Offenders Register',9)
,('66ca9d31-f02b-4461-b81a-d997b4e606fe','Disclosure Scotland Enhanced','contains information on convictions and cautions, information from Sex
Offenders Register',10)
,('2a569037-9636-4281-916f-dc848a9ec1bb','Protecting Vulnerable Groups (PVG) scheme','contains conviction information, and any other non-conviction
information that the police or other government bodies think is relevant',11)
,('b5c317c3-d3e8-4d83-807b-77e54e4ce53f','AccessNI Basic','contains details of all convictions considered to be unspent',12)
,('37fd85d7-884f-4484-aba6-46b01211410d','AccessNI Standard','contains details of all spent and unspent convictions, informed
warnings, cautions and diversionary youth conferences',13)
,('ec9949b9-0e6e-4b56-9176-e938bb0a1998','AccessNI Enhanced','contains the same information as a standard check and police records
held locally. To work with children and vulnerable adults, the check may
include information held by the Disclosure and Barring Service (DBS)',14);)

      db.query insert_query
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.load_static(directory = 'data/')
    DistributedLocks.distributed_lock(150) do
      p "Loading NUTS static data, Environment: #{Rails.env}"
      CCS.csv_to_nuts_regions directory + 'nuts1_regions.csv'
      CCS.csv_to_nuts_regions directory + 'nuts2_regions.csv'
      CCS.csv_to_nuts_regions directory + 'nuts3_regions.csv'
      p "Finished loading NUTS codes into db #{Rails.application.config.database_configuration[Rails.env]['database']}"

      p 'Loading FM regions static data'
      CCS.csv_to_fm_regions directory + 'facilities_management/regions.csv'
      p 'Loading FM rates static data'
      CCS.csv_to_fm_rates directory + 'facilities_management/rates.csv'
      p 'Loading security types static data'
      CCS.populate_security_types
      p 'Finished loading security types static data'
    end
  end
end

namespace :db do
  desc 'add NUTS static data to the database'
  task static: :environment do
    p 'Loading NUTS static'
    CCS.load_static
  end

  desc 'add static data to the database'
  task setup: :static do
  end
end
