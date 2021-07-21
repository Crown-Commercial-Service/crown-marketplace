module FacilitiesManagement::RM3830
  class QuickViewResultsSpreadsheetCreator
    attr_accessor :session_data

    def initialize(procurement_id)
      @procurement = Procurement.find(procurement_id)
      @buyer_detail = @procurement.user.buyer_detail
      @region_codes = @procurement.region_codes
      @service_codes = @procurement.service_codes
    end

    def build
      set_data
      create_spreadsheet
    end

    def to_xlsx
      @package.to_stream.read
    end

    private

    def set_data
      @regions = FacilitiesManagement::Region.where(code: @region_codes).map(&:name)
      @services = @service_codes.index_with { |code| Service.find_by(code: code).name }

      @lot_1a_suppliers = suppliers_for_lot('1a')
      @lot_1b_suppliers = suppliers_for_lot('1b')
      @lot_1c_suppliers = suppliers_for_lot('1c')
    end

    def create_spreadsheet
      @package = Axlsx::Package.new
      @workbook = @package.workbook

      add_styles

      add_regions
      add_services
      add_supplier_shortlists
      add_customer_details
    end

    def add_styles
      @styles = {}

      @workbook.styles do |styles|
        @styles[:heading_style] = styles.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }
        @styles[:bordered_heading_style] = styles.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        @styles[:underlined_heading_style] = styles.add_style sz: 12, b: true, u: true, alignment: { horizontal: :left, vertical: :center }
        @styles[:standard_column_style] = styles.add_style sz: 12, alignment: { wrap_text: true, horizontal: :left, vertical: :center }
        @styles[:standard_bordered_column_style] = styles.add_style sz: 12, alignment: { wrap_text: true, horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        @styles[:supplier_shortlist_style] = styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, fg_color: '6E6E6E'
      end
    end

    def add_regions
      @workbook.add_worksheet(name: 'Regions') do |sheet|
        sheet.add_row ['Regions'], style: @styles[:bordered_heading_style], height: LARGE_ROW_HEIGHT

        @regions.each do |region|
          sheet.add_row [region], style: @styles[:standard_bordered_column_style], height: LARGE_ROW_HEIGHT
        end

        sheet.column_widths(65)
      end
    end

    def add_services
      @workbook.add_worksheet(name: 'Services') do |sheet|
        sheet.add_row ['Service Reference', 'Service Name'], style: @styles[:bordered_heading_style], height: LARGE_ROW_HEIGHT

        @services.each do |service_ref, service_name|
          sheet.add_row [service_ref, service_name], style: @styles[:standard_bordered_column_style], height: LARGE_ROW_HEIGHT
        end

        sheet.column_widths(30, 75)
      end
    end

    def add_supplier_shortlists
      @workbook.add_worksheet(name: 'Supplier shortlists') do |sheet|
        sheet.add_row ['Quick view results', nil, nil], style: @styles[:heading_style], height: LARGE_ROW_HEIGHT
        sheet.add_row ['Here are the suppliers that can provide your services to your region(s). We are showing you potential suppliers from all three sub-lots, however, your procurement will fall into only one sub-lot dependent on your potential total contract value (which excludes billable works, optional extension periods and VAT).', nil, nil], style: @styles[:standard_column_style], height: LARGE_ROW_HEIGHT
        sheet.add_row ['To be placed compliantly into a sub-lot, please refer to Framework Schedule 7 - Call-off Procedure and Award Criteria', nil, nil], style: @styles[:standard_column_style], height: LARGE_ROW_HEIGHT
        sheet.add_row [], height: LARGE_ROW_HEIGHT

        sheet.add_row ['Suppliers shortlists', nil, nil], style: @styles[:underlined_heading_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Sub-lot 1a', 'Sub-lot 1b', 'Sub-lot 1c'], style: @styles[:heading_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Total contract value: up to £7m', 'Total contract value: between £7m - £50m', 'Total contract value: over £50m'], style: @styles[:heading_style], height: STANDARD_ROW_HEIGHT

        supplier_names_rows.each do |supplier_names_row|
          sheet.add_row supplier_names_row, style: @styles[:supplier_shortlist_style], height: STANDARD_ROW_HEIGHT
        end

        sheet.merge_cells 'A2:C2'
        sheet.merge_cells 'A3:C3'

        sheet.column_widths(50, 50, 50)
      end
    end

    # rubocop:disable Metrics/AbcSize
    def add_customer_details
      @workbook.add_worksheet(name: 'Customer Details') do |sheet|
        sheet.add_row ['Date/time production of this document:', Time.now.in_time_zone('London').strftime('%d/%m/%Y - %l:%M%P')], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Quick view search name', sanitize_string_for_excel(@procurement.contract_name)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row [], height: STANDARD_ROW_HEIGHT

        sheet.add_row ['Customer details', nil], style: @styles[:heading_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Buyer Organisation Name', sanitize_string_for_excel(@buyer_detail.organisation_name)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Buyer Organisation Address', sanitize_string_for_excel(@buyer_detail.full_organisation_address)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Buyer Contact Name', sanitize_string_for_excel(@buyer_detail.full_name)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Buyer Contact Job Title', sanitize_string_for_excel(@buyer_detail.job_title)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Buyer Contact Email Address', sanitize_string_for_excel(@buyer_detail.email)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row ['Buyer Contact Telephone Number', sanitize_string_for_excel(@buyer_detail.telephone_number)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT

        sheet.column_widths(40, 100)
      end
    end
    # rubocop:enable Metrics/AbcSize

    def supplier_names_rows
      supplier_names = [@lot_1a_suppliers, @lot_1b_suppliers, @lot_1c_suppliers]

      max_size = supplier_names.map(&:size).max

      max_size.times.map { |index| [supplier_names[0][index], supplier_names[1][index], supplier_names[2][index]] }
    end

    def suppliers_for_lot(lot)
      SupplierDetail.long_list_suppliers_lot(@region_codes, @service_codes, lot).map { |supplier| supplier['name'] }
    end

    def sanitize_string_for_excel(string)
      return "'#{string}" if string.match?(/\A(@|=|\+|-)/)

      string
    end

    LARGE_ROW_HEIGHT = 35
    STANDARD_ROW_HEIGHT = 25
  end
end
