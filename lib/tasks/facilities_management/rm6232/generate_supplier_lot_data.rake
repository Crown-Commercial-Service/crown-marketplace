module FM::RM6232
  module GenerateSupplierLotData
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier::LotData.destroy_all
    end

    def self.generate_suppliers_with_lot_data
      suppliers = FacilitiesManagement::RM6232::Supplier.all

      generate_lot_data(suppliers.shuffle)
    end

    def self.generate_lot_data(suppliers)
      lot_groups = [{ suppliers: suppliers[0..24], lot_code: 'a' }, { suppliers: suppliers[15..35], lot_code: 'b' }, { suppliers: suppliers[25..51], lot_code: 'c' }]

      lot_groups.each do |lot_group|
        SUPPLIER_SPLIT.each do |range, service_method, region_method|
          assign_services_and_regions(lot_group[:suppliers][range], lot_group[:lot_code], send(service_method), send(region_method))
        end

        random_services_and_regions(lot_group[:suppliers][16..], lot_group[:lot_code])
      end
    end

    SUPPLIER_SPLIT = [
      [0..4, :all_services, :all_regions],
      [5..9, :all_services, :regions_england_and_wales],
      [10..12, :hard_fm_services, :all_regions],
      [13..15, :soft_fm_services, :all_regions]
    ].freeze

    def self.all_services
      @all_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.pluck(:code) }.flatten
    end

    def self.all_core_services
      @all_core_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(core: true).pluck(:code) }.flatten
    end

    def self.all_additional_services
      @all_additional_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(core: false).pluck(:code) }.flatten
    end

    def self.hard_fm_services
      @hard_fm_services ||= sorted_service_codes((FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(hard: true).pluck(:code) }.flatten + all_core_services).uniq)
    end

    def self.soft_fm_services
      @soft_fm_services ||= sorted_service_codes((FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(soft: true).pluck(:code) }.flatten + all_core_services).uniq)
    end

    def self.service_codes_by_lot_number
      @service_codes_by_lot_number ||= {
        '1' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(total: true).pluck(:code) }.flatten,
        '2' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(hard: true).pluck(:code) }.flatten,
        '3' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(soft: true).pluck(:code) }.flatten
      }
    end

    def self.assign_services_and_regions(suppliers, lot_code, services, regions)
      suppliers.each do |supplier|
        %w[1 2 3].each do |lot_number|
          supplier.lot_data.create(lot_code: "#{lot_number}#{lot_code}", service_codes: services & service_codes_by_lot_number[lot_number], region_codes: regions)
        end
      end
    end

    def self.random_services_and_regions(suppliers, lot_code)
      suppliers.each do |supplier|
        services = random_service_codes

        %w[1 2 3].each do |lot_number|
          supplier.lot_data.create(lot_code: "#{lot_number}#{lot_code}", service_codes: services & service_codes_by_lot_number[lot_number], region_codes: random_region_codes)
        end
      end
    end

    def self.random_service_codes
      service_sample_size = (number_of_services * (rand(0..15) / 20.0)).to_i

      service_code_selection = all_additional_services.sample(service_sample_size) + all_core_services

      sorted_service_codes(service_code_selection.uniq)
    end

    def self.number_of_services
      @number_of_services ||= all_additional_services.count
    end

    def self.all_regions
      @all_regions ||= FacilitiesManagement::Region.all.reject { |region| region.code == 'OS01' }.map(&:code)
    end

    def self.regions_england_and_wales
      @regions_england_and_wales ||= all_regions.reject { |code| code.starts_with?('UKM') || code.starts_with?('UKN') }
    end

    TOTAL_REGION_COUNT = 73

    def self.random_region_codes
      region_sample_size = (TOTAL_REGION_COUNT * (rand(8..15) / 20.0)).to_i

      all_regions.sample(region_sample_size).sort
    end

    def self.sorted_service_codes(service_codes)
      service_codes.sort_by { |service_code| all_service_codes_sorted.index(service_code) }
    end

    def self.all_service_codes_sorted
      @all_service_codes_sorted ||= FacilitiesManagement::RM6232::Service.order(:work_package_code, :sort_order).pluck(:code)
    end

    def self.convert_to_spreadsheets
      FM::RM6232::ServiceDataSpreadsheet.new.convert_to_spreadsheet
      FM::RM6232::RegionDataSpreadsheet.new.convert_to_spreadsheet
    end
  end
end

module FM::RM6232
  class SupplierSpreadsheet
    def initialize(filename)
      @filename = filename
      @package = Axlsx::Package.new
      @workbook = @package.workbook
      @styles = {}
    end

    def convert_to_spreadsheet
      set_up_spreadsheet
      create_spreadsheet
      save_spreadsheet
    end

    private

    def save_spreadsheet
      file_path = Rails.root.join('data', 'facilities_management', 'rm6232', @filename)

      File.write(file_path, @package.to_stream.read, binmode: true)
    end

    def lot_suppliers(lot_code)
      suppliers = FacilitiesManagement::RM6232::Supplier::LotData.where(lot_code: lot_code).map do |lot_data|
        supplier = lot_data.supplier

        {
          supplier_name: supplier.supplier_name,
          duns: supplier.duns,
          service_codes: lot_data.service_codes,
          region_codes: lot_data.region_codes
        }
      end

      suppliers.sort_by { |supplier_data| supplier_data[:supplier_name] }
    end
  end

  class ServiceDataSpreadsheet < SupplierSpreadsheet
    def initialize
      super('RM6232 Supplier Services (for Dev & Test).xlsx')
    end

    private

    def set_up_spreadsheet
      @workbook.styles do |styles|
        @styles[:normal_row] = styles.add_style sz: 11, alignment: { horizontal: :center, vertical: :center }, border: { style: :thin, color: '000000' }
        @styles[:work_package_row] = styles.add_style sz: 11, b: true, border: { style: :thin, color: '000000' }
        @styles[:header_row] = styles.add_style sz: 9, b: true
        @styles[:supplier_names_row] = styles.add_style sz: 12, b: true, alignment: { horizontal: :center, vertical: :bottom, wrap_text: true }, border: { style: :thin, color: '000000' }, bg_color: 'FFFF00'
        @styles[:normal_row_with_colour] = styles.add_style sz: 11, alignment: { horizontal: :center, vertical: :center }, border: { style: :thin, color: '000000' }, bg_color: 'FFFF00'
        @styles[:normal_row_left_align] = styles.add_style sz: 11, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
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
      sheet.add_row [nil] * 4 + suppliers.map { |supplier_data| supplier_data[:supplier_name] }
      sheet.add_row [nil] * 4 + suppliers.map { |supplier_data| supplier_data[:duns] }, types: [:string] * (4 + suppliers.length)
      sheet.add_row ['Work package Description', 'Work Package Standard Reference (where applicable)', 'Work Package Section Reference', 'Service'] + (['Are you able to provide this additional service?'] * suppliers.length), style: @styles[:header_row]
    end

    # rubocop:disable Metrics/AbcSize
    def add_service_rows(sheet, lot_number, suppliers)
      work_packages[lot_number].each do |work_package_services|
        work_package = work_package_services.first.work_package
        sheet.add_row ["Work Package #{work_package.code} - #{work_package.name}"], style: @styles[:work_package_row]

        work_package_services.each do |service|
          service_code = service.code

          supplier_answers = suppliers.map { |supplier_data| supplier_data[:service_codes].include?(service_code) ? 'Yes' : 'No' }

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

  class RegionDataSpreadsheet < SupplierSpreadsheet
    def initialize
      super('RM6232 Supplier Regions (for Dev & Test).xlsx')
    end

    private

    def set_up_spreadsheet
      @workbook.styles do |styles|
        @styles[:heading_style] = styles.add_style sz: 12, b: true, bg_color: 'FBE4D5', fg_color: '000000', alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
        @styles[:normal_row]    = styles.add_style sz: 12, b: false, alignment: { horizontal: :left, vertical: :center }, border: { style: :thin, color: '000000' }
        @styles[:row_height]    = 25
      end
    end

    def create_spreadsheet
      %w[1 2 3].each do |lot_number|
        %w[a b c].each do |lot_letter|
          lot_code = "#{lot_number}#{lot_letter}"

          suppliers = lot_suppliers(lot_code)

          @workbook.add_worksheet(name: "Lot #{lot_code}") do |sheet|
            sheet.add_row ['Supplier', 'DUNS Number'] + region_codes, style: @styles[:heading_style], height: @styles[:row_height]

            suppliers.each do |supplier|
              supplier_regions_marked = region_codes.map { |region_code| 'X' if supplier[:region_codes].include?(region_code) }
              sheet.add_row [supplier[:supplier_name], supplier[:duns]] + supplier_regions_marked, style: @styles[:normal_row], height: @styles[:row_height], types: [:string] * NUMBER_OF_COLUMNS
            end
          end
        end
      end
    end

    def region_codes
      @region_codes ||= FacilitiesManagement::Region.all.map(&:code)[0..-2] + ['NC01', 'OS01']
    end

    NUMBER_OF_COLUMNS = 78
  end
end

# This task was created to generate the test data
# You should need to run it again as it will change the tests data and break tests
namespace :db do
  namespace :rm6232 do
    desc 'Generate the supplier lot data and converts to JSON'
    task generate_supplier_lot_data: :environment do
      DistributedLocks.distributed_lock(192) do
        ActiveRecord::Base.transaction do
          FM::RM6232::GenerateSupplierLotData.truncate_tables
          FM::RM6232::GenerateSupplierLotData.generate_suppliers_with_lot_data
          FM::RM6232::GenerateSupplierLotData.convert_to_spreadsheets
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end

    desc 'Part of generating the full supplier details'
    task generate_suppliers: :generate_supplier_lot_data do
    end
  end
end
