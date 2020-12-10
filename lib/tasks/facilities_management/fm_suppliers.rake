module CCS
  require 'pg'
  require 'csv'
  require 'json'
  require 'roo'
  require Rails.root.join('lib', 'tasks', 'distributed_locks')

  def self.supplier_data
    is_dev_db = ENV['CCS_DEFAULT_DB_HOST']
    # nb reinstate || (is_dev_db.include? 'dev')
    if is_dev_db.nil? || (%w[dev. cmpdefault.db.internal.fm-preview preview sandbox].any? { |env| is_dev_db.include?(env) })
      puts 'dummy supplier data'
      JSON File.read('data/' + 'facilities_management/dummy_supplier_data.json')
    elsif ENV['SECRET_KEY_BASE']
      puts 'real supplier data'
      JSON fm_aws
    end
  end

  def self.fm_suppliers
    CCS::FM::Supplier.destroy_all
    supplier_data.each do |data|
      full_lot_data = {}

      ['1a', '1b', '1c'].each do |lot_number|
        lot_data = data['lots'].find { |lot| lot['lot_number'] == lot_number }
        full_lot_data[lot_number] = { regions: lot_data['regions'], services: lot_data['services'] } if lot_data
      end

      CCS::FM::Supplier.create(
        supplier_id: data['supplier_id'],
        contact_name: data['contact_name'],
        contact_email: data['contact_email'],
        contact_phone: data['contact_phone'],
        supplier_name: data['supplier_name'],
        lot_data: full_lot_data
      )
    end
  rescue PG::Error => e
    puts e.message
  end

  # rubocop:disable Metrics/AbcSize
  def self.fm_supplier_contact_details
    FacilitiesManagement::SupplierDetail.destroy_all
    supplier_contact_details = Roo::Spreadsheet.open(supplier_details_path, extension: :xlsx)
    supplier_contact_details.sheet(0).drop(1).each do |row|
      contact_email = row[8]&.strip
      FacilitiesManagement::SupplierDetail.create(
        user: User.find_by(email: contact_email),
        name: row[1]&.strip,
        lot1a: row[2].to_s.downcase.include?('x'),
        lot1b: row[3].to_s.downcase.include?('x'),
        lot1c: row[4].to_s.downcase.include?('x'),
        direct_award: row[5].to_s.downcase.include?('yes'),
        sme: row[6].to_s.downcase.include?('yes'),
        contact_name: row[7]&.strip,
        contact_email: contact_email,
        contact_number: row[9]&.strip,
        duns: row[10],
        registration_number: row[11],
        address_line_1: row[12]&.strip,
        address_line_2: row[13]&.strip,
        address_town: row[14]&.strip,
        address_county: row[15]&.strip,
        address_postcode: row[16]&.strip
      )
    end

    File.delete(supplier_details_path) if File.exist?(supplier_details_path) && Rails.env.production?
  rescue PG::Error => e
    puts e.message
  end
  # rubocop:enable Metrics/AbcSize

  def self.supplier_details_path
    if Rails.env.production?
      s3_resource = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object = s3_resource.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(ENV['SUPPLIER_DETAILS_DATA_KEY'])
      response_target = 'data/facilities_management/Supplier_details_data.xlsx'
      object.get(response_target: response_target)
      response_target
    else
      Rails.root.join('data', 'facilities_management', 'RM3830 Suppliers Details (for Dev & Test).xlsx')
    end
  end

  def self.extend_timeout
    Aws.config[:http_open_timeout] = 600
    Aws.config[:http_read_timeout] = 600
    Aws.config[:http_idle_timeout] = 600
  end

  def self.awd_credentials(access_key, secret_key, bucket, region)
    Aws.config[:credentials] = Aws::Credentials.new(access_key, secret_key)
    p "Importing from AWS bucket: #{bucket}, region: #{region}"

    extend_timeout
  end

  # EDITOR=vim rails credentials:edit
  def self.fm_aws
    s3_resource = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
    object = s3_resource.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(ENV['JSON_SUPPLIER_DATA_KEY'])
    object.get.body.string
  end
end

namespace :db do
  desc 'download from aws'
  task aws: :environment do
    p 'Loading FM Suppliers static'
    DistributedLocks.distributed_lock(152) do
      CCS::FM::Supplier.destroy_all
      CCS.fm_suppliers
      CCS.fm_supplier_contact_details
    end
  end

  desc 'add static data to the database'
  task static: :aws do
  end
end
