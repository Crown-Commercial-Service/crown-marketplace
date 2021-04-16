module FacilitiesManagement::RakeModules::SupplierRateCards
  def self.import_rate_cards_for_suppliers(method)
    rate_cards_workbook = Roo::Spreadsheet.open(spreadsheet_path, extension: :xlsx)
    @data = { 'Prices' => lot_1a_suppliers, 'Discounts' => lot_1a_suppliers, 'Variances' => lot_1a_suppliers }
    @method = method

    add_prices(rate_cards_workbook.sheet('Prices'))
    add_variances(rate_cards_workbook.sheet('Variances'))

    File.delete(spreadsheet_path) if File.exist?(spreadsheet_path) && Rails.env.production?

    rate_card = CCS::FM::RateCard.create(data: converted_data, source_file: spreadsheet_name)

    Rails.logger.info "FM rate cards spreadsheet #{spreadsheet_name} (#{rate_card.data.count} sheets) imported into database"
  end

  def self.spreadsheet_path
    @spreadsheet_path ||= if Rails.env.production?
                            s3_resource = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
                            object = s3_resource.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(ENV['DIRECT_AWARD_DATA_KEY'])
                            object.get(response_target: 'data/facilities_management/DA_data.xlsx')
                            'data/facilities_management/DA_data.xlsx'
                          else
                            Rails.root.join('data', 'facilities_management', 'RM3830 Direct Award Data (for Dev & Test).xlsx')
                          end
  end

  def self.spreadsheet_name
    @spreadsheet_name ||= spreadsheet_path.to_s.split('/').last
  end

  def self.lot_1a_suppliers
    FacilitiesManagement::SupplierDetail.all.select { |supplier| supplier.lot_data.keys.include? '1a' }.map { |supplier| [supplier.supplier_name, {}] }.to_h
  end

  def self.add_prices(sheet)
    labels = sheet.row(1)[0..-2]
    last_row = sheet.last_row

    (2..last_row).each do |row_number|
      row = sheet.row(row_number)
      rate_card = labels.zip(row).to_h

      next unless rate_card['Service Ref']

      @data['Prices'][rate_card['Supplier']] ||= {}

      @data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
      add_discounts(row.last.abs, rate_card)
    end
  end

  def self.add_discounts(discount, rate_card)
    @data['Discounts'][rate_card['Supplier']] ||= {}

    @data['Discounts'][rate_card['Supplier']][rate_card['Service Ref']] = { 'Disc %' => discount }.merge(rate_card.slice('Supplier', 'Service Ref', 'Service Name'))
  end

  def self.add_variances(sheet)
    labels = sheet.column(1)
    last_column = sheet.last_column

    (2..last_column).each do |column_number|
      column = sheet.column(column_number)

      rate_card = labels.zip(column).to_h

      @data['Variances'][rate_card['Supplier']] ||= {}

      @data['Variances'][rate_card['Supplier']] = rate_card
    end
  end

  def self.converted_data
    Rails.logger.info 'Converting supplier names to IDs'
    case @method
    when :add
      FacilitiesManagement::RakeModules::ConvertSupplierNames.new(:supplier_name_to_id).map_supplier_keys(@data)
    when :update
      FacilitiesManagement::RakeModules::ConvertSupplierNames.new(:current_supplier_name_to_id).map_supplier_keys(@data)
    end
  end
end
