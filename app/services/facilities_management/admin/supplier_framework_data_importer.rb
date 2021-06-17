class FacilitiesManagement::Admin::SupplierFrameworkDataImporter
  IMPORT_PROCESS_ORDER = %i[check_file process_file publish_data].freeze

  def initialize(supplier_data_upload = nil)
    @supplier_data_upload = supplier_data_upload
    @errors = []
  end

  def import_data
    IMPORT_PROCESS_ORDER.each do |import_process|
      @supplier_data_upload.send("#{import_process}!")
      send(import_process)
      break if @errors.any?
    end

    if @errors.any?
      @supplier_data_upload.update(import_errors: @errors)
      @supplier_data_upload.fail!
    else
      @supplier_data_upload.publish!
    end
  rescue StandardError => e
    @supplier_data_upload.update(import_errors: ['upload_failed'])
    @supplier_data_upload.fail!

    Rollbar.log('error', e)
  end

  def import_test_data
    @test_supplier_data_spreadsheet = Rails.root.join('data', 'facilities_management', 'RM3830 Direct Award Data (for Dev & Test).xlsx')

    process_file
    publish_data
  end

  private

  def check_file
    read_spreadsheet do |supplier_data_workbook|
      if supplier_data_workbook.sheets != ['Prices', 'Variances']
        @errors << 'supplier_details_missing_sheets'
      else
        @errors << 'pricing_sheet_headers_incorrect' if supplier_data_workbook.sheet(0).row(1) != ['Supplier', 'Service Ref', 'Service Name', 'Unit of Measure', 'General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary Schools', 'Special Schools', 'Universities and Colleges', 'Community - Doctors, Dentist, Health Clinic', 'Nursing and Care Homes', 'Direct Award Discount %']
        @errors << 'variances_sheet_headers_incorrect' if supplier_data_workbook.sheet(1).column(1) != ['Supplier', 'Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)']
      end
    end
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << 'file_check_failed'
  end

  def process_file
    @supplier_data = { 'Prices' => lot_1a_suppliers, 'Discounts' => lot_1a_suppliers, 'Variances' => lot_1a_suppliers }

    read_spreadsheet do |supplier_data_workbook|
      add_prices(supplier_data_workbook.sheet('Prices'))
      add_variances(supplier_data_workbook.sheet('Variances'))
    end
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << 'file_process_failed'
  end

  def lot_1a_suppliers
    FacilitiesManagement::SupplierDetail.suppliers_offering_lot('1a').index_with { {} }
  end

  def add_prices(sheet)
    labels = sheet.row(1)[0..-2]
    last_row = sheet.last_row

    (2..last_row).each do |row_number|
      row = sheet.row(row_number)
      rate_card = labels.zip(row).to_h

      next unless rate_card['Service Ref']

      @supplier_data['Prices'][rate_card['Supplier']] ||= {}

      @supplier_data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
      add_discounts(row.last.abs, rate_card)
    end
  end

  def add_discounts(discount, rate_card)
    @supplier_data['Discounts'][rate_card['Supplier']] ||= {}

    @supplier_data['Discounts'][rate_card['Supplier']][rate_card['Service Ref']] = { 'Disc %' => discount }.merge(rate_card.slice('Supplier', 'Service Ref', 'Service Name'))
  end

  def add_variances(sheet)
    labels = sheet.column(1)
    last_column = sheet.last_column

    (2..last_column).each do |column_number|
      column = sheet.column(column_number)

      rate_card = labels.zip(column).to_h

      @supplier_data['Variances'][rate_card['Supplier']] ||= {}

      @supplier_data['Variances'][rate_card['Supplier']] = rate_card
    end
  end

  def publish_data
    rate_card = CCS::FM::RateCard.create(data: converted_data, source_file: file_source)

    Rails.logger.info "FM rate cards spreadsheet #{file_source} (#{rate_card.data.count} sheets) imported into database"
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << 'file_publish_failed'
  end

  def converted_data
    FacilitiesManagement::RakeModules::ConvertSupplierNames.new(:current_supplier_name_to_id).map_supplier_keys(@supplier_data)
  end

  def file_source
    @test_supplier_data_spreadsheet || @supplier_data_upload.supplier_data_file.filename.to_s
  end

  def read_spreadsheet
    workbook = Roo::Spreadsheet.open(@test_supplier_data_spreadsheet || supplier_data_spreadsheet, extension: :xlsx)

    yield(workbook)

    workbook.close
  end

  def supplier_data_spreadsheet
    tmpfile = Tempfile.create
    tmpfile.binmode
    tmpfile.write @supplier_data_upload.supplier_data_file.download
    tmpfile.close

    tmpfile.path
  end
end
