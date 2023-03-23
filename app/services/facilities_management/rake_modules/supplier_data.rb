# rubocop:disable Rails/Output
module FacilitiesManagement::RakeModules::SupplierData
  def self.supplier_data
    if Rails.env.production?
      puts 'supplier data from aws'
      JSON fm_aws
    else
      puts 'dummy supplier data'
      JSON File.read('data/facilities_management/rm3830/dummy_supplier_data.json')
    end
  end

  def self.fm_suppliers
    supplier_data.each do |data|
      full_lot_data = {}

      ['1a', '1b', '1c'].each do |lot_number|
        lot_data = data['lots'].find { |lot| lot['lot_number'] == lot_number }
        full_lot_data[lot_number] = { regions: lot_data['regions'], services: lot_data['services'] } if lot_data
      end

      FacilitiesManagement::RM3830::SupplierDetail.create(
        supplier_id: data['supplier_id'],
        contact_name: data['contact_name'],
        contact_email: data['contact_email'],
        contact_phone: data['contact_phone'],
        supplier_name: data['supplier_name'],
        lot_data: full_lot_data,
        user: User.find_by(email: data['contact_email'])
      )
    end
  rescue PG::Error => e
    puts e.message
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def self.fm_supplier_contact_details
    supplier_contact_details = Roo::Spreadsheet.open(supplier_details_path, extension: :xlsx)
    supplier_contact_details.sheet(0).drop(1).each do |row|
      supplier_detail = FacilitiesManagement::RM3830::SupplierDetail.find_by(contact_email: row[8]&.strip)
      supplier_detail.update(
        contact_name: row[7]&.strip,
        contact_phone: row[9]&.strip,
        sme: row[5].to_s.downcase.include?('yes'),
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
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def self.supplier_details_path
    if Rails.env.production?
      s3_resource = Aws::S3::Resource.new(region: ENV.fetch('COGNITO_AWS_REGION', nil))
      object = s3_resource.bucket(ENV.fetch('CCS_APP_API_DATA_BUCKET', nil)).object(ENV.fetch('SUPPLIER_DETAILS_DATA_KEY', nil))
      response_target = 'data/facilities_management/rm3830/Supplier_details_data.xlsx'
      object.get(response_target: response_target)
      response_target
    else
      Rails.root.join('data', 'facilities_management', 'rm3830', 'RM3830 Suppliers Details (for Dev & Test).xlsx')
    end
  end

  def self.extend_timeout
    Aws.config[:http_open_timeout] = 600
    Aws.config[:http_read_timeout] = 600
    Aws.config[:http_idle_timeout] = 600
  end

  def self.awd_credentials(access_key, secret_key, bucket, region)
    Aws.config[:credentials] = Aws::Credentials.new(access_key, secret_key)
    puts "Importing from AWS bucket: #{bucket}, region: #{region}"

    extend_timeout
  end

  # EDITOR=vim rails credentials:edit
  def self.fm_aws
    s3_resource = Aws::S3::Resource.new(region: ENV.fetch('COGNITO_AWS_REGION', nil))
    object = s3_resource.bucket(ENV.fetch('CCS_APP_API_DATA_BUCKET', nil)).object(ENV.fetch('JSON_SUPPLIER_DATA_KEY', nil))
    object.get.body.string
  end

  def self.supplier_data_mapping
    supplier_data.to_h { |supplier_data| [supplier_data['supplier_name'], supplier_data['supplier_id']] }
  end

  def self.current_supplier_data_mapping
    FacilitiesManagement::RM3830::SupplierDetail.pluck(:supplier_name, :supplier_id).to_h
  end
end
# rubocop:enable Rails/Output
