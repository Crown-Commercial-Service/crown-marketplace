module FacilitiesManagement::RM6232
  module Admin
    class SupplierSpreadsheet::Services < FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet
      private

      def add_styles
        super do |styles|
          @styles[:normal_row]              = styles.add_style sz: 11, alignment: { horizontal: :center, vertical: :center }, border: { style: :thin, color: '000000' }
          @styles[:work_package_row]        = styles.add_style sz: 11, b: true, border: { style: :thin, color: '000000' }
          @styles[:header_row]              = styles.add_style sz: 9, b: true
          @styles[:supplier_names_row]      = styles.add_style sz: 12, b: true, alignment: { horizontal: :center, vertical: :bottom, wrap_text: true }, border: { style: :thin, color: '000000' }, bg_color: 'FFFF00'
          @styles[:normal_row_with_colour]  = styles.add_style sz: 11, alignment: { horizontal: :center, vertical: :center }, border: { style: :thin, color: '000000' }, bg_color: 'FFFF00'
          @styles[:normal_row_left_align]   = styles.add_style sz: 11, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
        end
      end

      def create_spreadsheet
        %w[1 2 3].each do |lot_number|
          %w[a b c].each do |lot_letter|
            lot_code = "#{lot_number}#{lot_letter}"

            suppliers = lot_suppliers(lot_code)

            @workbook.add_worksheet(name: "Lot #{lot_code}") do |sheet|
              add_header_rows(sheet, lot_code, suppliers)
              add_service_rows(sheet, lot_number, suppliers)
              style_sheet(sheet, lot_number, suppliers)
            end
          end
        end
      end

      def add_header_rows(sheet, lot_code, suppliers)
        sheet.add_row ["If you are bidding for Lot #{lot_code}, please confirm within the Yellow highlighted cells, that you are able to provide the relevant additional service"], style: @styles[:header_row]
        sheet.add_row [nil, nil, nil, 'Supplier name'] + suppliers.pluck('supplier_name'), style: @styles[:header_row]
        sheet.add_row [nil, nil, nil, 'DUNS number'] + suppliers.pluck('duns'), types: [:string] * (4 + suppliers.length), style: @styles[:header_row]
        sheet.add_row ['Work package Description', 'Work Package Standard Reference (where applicable)', 'Work Package Section Reference', 'Service'] + (['Are you able to provide this additional service?'] * suppliers.length), style: @styles[:header_row]
      end

      # rubocop:disable Metrics/AbcSize
      def add_service_rows(sheet, lot_number, suppliers)
        work_packages[lot_number].each do |work_package_services|
          work_package = work_package_services.first.work_package
          sheet.add_row ["Work Package #{work_package.code} - #{work_package.name}"], style: @styles[:work_package_row]

          work_package_services.each do |service|
            service_code = service.code

            supplier_answers = suppliers.map { |supplier_data| supplier_data['service_codes'].include?(service_code) ? 'Yes' : 'No' }

            sheet.add_row ["Service #{service_code.gsub('.', ':')} - #{service.name}", "S#{service_code.gsub('.', '')}", service_codes.index(service_code) + 2, 'Additional'] + supplier_answers, style: @styles[:normal_row]
          end
          sheet.add_row []
        end
      end

      def style_sheet(sheet, lot_number, suppliers)
        sheet.column_widths(*(COLUMN_WIDTHS + ([SUPPLIER_COLUMN_WIDTH] * suppliers.length)))
        sheet.rows[1..2].each { |row| row.cells[4..].each { |cell| cell.style = @styles[:supplier_names_row] } }

        current_row = 5

        work_packages[lot_number].map(&:length).each do |number_of_services|
          sheet.rows[current_row..(current_row - 1 + number_of_services)].each do |row|
            row.cells[0].style = @styles[:normal_row_left_align]
            row.cells[4..].each { |cell| cell.style = @styles[:normal_row_with_colour] }
          end

          current_row += number_of_services + 2
        end
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/CyclomaticComplexity
      def work_packages
        @work_packages ||= {
          '1' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(total: true, core: false) }.reject(&:empty?),
          '2' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(hard: true, core: false) }.reject(&:empty?),
          '3' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(soft: true, core: false) }.reject(&:empty?)
        }
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      def service_codes
        @service_codes ||= FacilitiesManagement::RM6232::Service.order(:work_package_code, :sort_order).pluck(:code)
      end

      COLUMN_WIDTHS = [75, 10, 10, 10].freeze
      SUPPLIER_COLUMN_WIDTH = 20
    end
  end
end
