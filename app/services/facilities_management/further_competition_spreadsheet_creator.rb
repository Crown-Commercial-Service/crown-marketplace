class FacilitiesManagement::FurtherCompetitionSpreadsheetCreator < FacilitiesManagement::DeliverableMatrixSpreadsheetCreator
  include FurtherCompetitionConcern

  attr_accessor :session_data

  def build(start_date, current_user)
    @package = Axlsx::Package.new do |p|
      p.workbook.styles do |s|
        first_column_style = s.add_style sz: 12, b: true, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_column_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }
        standard_bold_style = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }, b: true

        p.workbook.add_worksheet(name: 'Buildings information') do |sheet|
          add_header_row(sheet, ['Buildings information'])
          add_buildings_information(sheet)
          style_buildings_information_sheet(sheet, first_column_style)
        end

        p.workbook.add_worksheet(name: 'Service Matrix') do |sheet|
          add_header_row(sheet, ['Service Reference', 'Service Name'])
          add_service_matrix(sheet)
          style_service_matrix_sheet(sheet, standard_column_style)
        end

        unless @units_of_measure_values.nil?
          p.workbook.add_worksheet(name: 'Volume') do |sheet|
            add_header_row(sheet, ['Service Reference',	'Service Name',	'Metric per annum'])
            number_volume_services = add_volumes_information(sheet)
            style_volume_sheet(sheet, standard_column_style, number_volume_services)
          end
        end

        add_other_competition_worksheets(p, standard_column_style, standard_bold_style, start_date, current_user)
      end
    end
  end

  def add_other_competition_worksheets(package, standard_column_style, standard_bold_style, start_date, current_user)
    add_service_periods_worksheet(package, standard_column_style)

    add_shortlist_details(package, standard_column_style, standard_bold_style, start_date, current_user)

    add_customer_and_contract_details(package) if @procurement
  end

  def add_shortlist_details(package, standard_column_style, standard_bold_style, start_date, current_user)
    package.workbook.add_worksheet(name: 'Shortlist') do |sheet|
      add_shortlist_contract_number(sheet, standard_column_style)
      add_shortlist_cost_sublot_recommendation(sheet, start_date, current_user, standard_column_style, standard_bold_style)
      sheet.add_row [], style: standard_column_style, height: standard_row_height

      add_shortlist_supplier_names(sheet)

      style_shortlist_sheet(sheet)
    end
  end

  def add_shortlist_contract_number(sheet, style)
    time = Time.now.getlocal
    sheet.add_row ["#{calculate_contract_number} - #{time.strftime('%d/%m/%Y')} - #{time.strftime('%l:%M%P')}"], style: style, height: standard_row_height
    sheet.add_row [], style: style, height: standard_row_height
  end

  def calculate_contract_number
    FacilitiesManagement::ContractNumberGenerator.new(procurement_state: :further_competition, used_numbers: []).new_number
  end

  def add_shortlist_cost_sublot_recommendation(sheet, start_date, current_user, standard_style, bold_style)
    sheet.add_row ['Cost and sub-lot recommendation'], style: bold_style, height: standard_row_height

    build_direct_award_report(true,  start_date, current_user, session_data)

    da_value = @report.assessed_value
    sheet.add_row ['Estimated cost', ActionController::Base.helpers.number_to_currency(da_value, unit: '£', precision: 2), '(Partial estimated cost) / (Estimated cost not calculated)'], style: standard_style, height: standard_row_height
    sheet.add_row ['Sub-lot recommendation', 'Sub-lot ' + @report.current_lot, '(Customer selected)'], style: standard_style, height: standard_row_height
    sheet.add_row ['Sub-lot value range', determine_lot_range], style: standard_style, height: standard_row_height
  end

  def add_customer_and_contract_details(package)
    package.workbook.add_worksheet(name: 'Customer & Contract Details') do |sheet|
      add_customer_details(sheet)
      add_contract_requirements(sheet)
    end
  end

  def add_customer_details(sheet)
    bold_style = sheet.styles.add_style b: true
    telephone_number_style = sheet.styles.add_style format_code: '0##########', alignment: { horizontal: :left }
    buyer_detail = @procurement.user.buyer_detail

    sheet.add_row ['1. Customer details'], style: bold_style
    sheet.add_row ['Contract Name', @procurement.contract_name]
    sheet.add_row ['Buyer Organisation Name', buyer_detail.organisation_name]
    sheet.add_row ['Buyer Organisation Address', get_address(buyer_detail)]
    sheet.add_row ['Buyer Organisation Sector', buyer_detail.central_government? ? 'Central Government' : 'Wider Public Sector']
    sheet.add_row ['Buyer Contact Name', buyer_detail.full_name]
    sheet.add_row ['Buyer Contact Job Title', buyer_detail.job_title]
    sheet.add_row ['Buyer Contact Email Address', @procurement.user.email]
    sheet.add_row ['Buyer Contact Telephone Number', buyer_detail.telephone_number], style: [nil, telephone_number_style]
  end

  def get_address(buyer_detail)
    str_array = [buyer_detail.organisation_address_line_1,
                 buyer_detail.organisation_address_line_2,
                 buyer_detail.organisation_address_town,
                 buyer_detail.organisation_address_county]
    str_array.reject(&:blank?).join(', ') + '. ' + buyer_detail.organisation_address_postcode
  end

  def determine_lot_range
    lot_range = 'UNKNOWN'
    case @report.current_lot
    when '1a'
      lot_range = 'Up to £7m'
    when '1b'
      lot_range = 'between £7m-50m'
    when '1c'
      lot_range = 'over £50m'
    end
    lot_range
  end

  def add_shortlist_supplier_names(sheet)
    standard_style = sheet.styles.add_style sz: 12, border: { style: :thin, color: '00000000' }, alignment: { wrap_text: true, vertical: :center, horizontal: :center }, fg_color: '6E6E6E'
    bold_style = sheet.styles.add_style sz: 12, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '00000000' }, b: true

    label = 'Suppliers shortlist'
    supplier_names = @rate_card.data[:Prices].keys
    supplier_names.each do |supplier_name|
      sheet.add_row [label, supplier_name], style: standard_style, height: standard_row_height
      label = nil
    end

    sheet['A8:A8'].each { |c| c.style = bold_style }
  end

  def style_supplier_names_sheet(sheet, style, rows_added)
    column_widths = [75, 50]
    sheet["A2:B#{rows_added + 1}"].each { |c| c.style = style }
    sheet.column_widths(*column_widths)
  end

  def style_shortlist_sheet(sheet)
    column_widths = [50, 50, 50]
    sheet.column_widths(*column_widths)
  end

  def list_of_allowed_volume_services
    %w[C.5 E.4 G.1 G.3 G.5 H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 K.1 K.2 K.3 K.4 K.5 K.6 K.7]
  end
end
