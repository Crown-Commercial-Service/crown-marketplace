module FacilitiesManagement
  class SupplierShortlistSpreadsheet
    def initialize(procurement, customer_details_title)
      @procurement = procurement
      @buyer_detail = @procurement.user.buyer_detail
      @customer_details_title = customer_details_title
    end

    def build
      set_data
      create_spreadsheet
    end

    def to_xlsx
      @package.to_stream.read
    end

    private

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
        @styles[:currency_column_style] = styles.add_style sz: 12, alignment: { wrap_text: true, horizontal: :left, vertical: :center }, format_code: '£#,##0;'
        @styles[:standard_bordered_column_style] = styles.add_style sz: 12, alignment: { wrap_text: true, horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        @styles[:supplier_shortlist_style] = styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, fg_color: '6E6E6E'
      end
    end

    def add_regions
      @workbook.add_worksheet(name: 'Regions') do |sheet|
        sheet.add_row ['NUTS Code', 'Region Name'], style: @styles[:bordered_heading_style], height: LARGE_ROW_HEIGHT

        @regions.each do |region|
          sheet.add_row [region.code, region.name], style: @styles[:standard_bordered_column_style], height: LARGE_ROW_HEIGHT
        end

        sheet.column_widths(*COLUMN_WIDTHS)
      end
    end

    def add_services
      @workbook.add_worksheet(name: 'Services') do |sheet|
        sheet.add_row ['Service Reference', 'Service Name'], style: @styles[:bordered_heading_style], height: LARGE_ROW_HEIGHT

        @services.each do |service_ref, service_name|
          sheet.add_row [service_ref, service_name], style: @styles[:standard_bordered_column_style], height: LARGE_ROW_HEIGHT
        end

        sheet.column_widths(*COLUMN_WIDTHS)
      end
    end

    # rubocop:disable Metrics/AbcSize
    def add_customer_details
      @workbook.add_worksheet(name: 'Customer Details') do |sheet|
        sheet.add_row ['Date/time production of this document:', Time.now.in_time_zone('London').strftime('%d/%m/%Y - %l:%M%P')], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
        sheet.add_row [@customer_details_title, sanitize_string_for_excel(@procurement.contract_name)], style: @styles[:standard_column_style], height: STANDARD_ROW_HEIGHT
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

    def sanitize_string_for_excel(string)
      return "'#{string}" if string.match?(/\A(@|=|\+|-)/)

      string
    end

    LARGE_ROW_HEIGHT = 35
    STANDARD_ROW_HEIGHT = 25
    COLUMN_WIDTHS = [30, 75].freeze
  end
end
