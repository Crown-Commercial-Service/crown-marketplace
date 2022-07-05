module FacilitiesManagement::RM6232
  module Admin
    class ManagementReportCsvGenerator
      def initialize(id)
        @management_report = ManagementReport.find(id)
        @start_date = @management_report.start_date
        @end_date = @management_report.end_date
      end

      def generate
        report_csv = StringIO.new generate_csv
        @management_report.management_report_csv.attach(io: report_csv, filename: "procurements_data_#{created_at}_#{date_to_string(@start_date)}-#{date_to_string(@end_date)}.csv", content_type: 'text/csv')
        @management_report.complete
        @management_report.save
      end

      private

      def generate_csv
        CSV.generate do |csv|
          csv << COLUMN_LABELS
          find_procurements.each { |procurement| csv << create_procurement_row(procurement) }
        end
      end

      def find_procurements
        Procurement.where(created_at: (@start_date..(@end_date + 1))).order(created_at: :desc)
      end

      # rubocop:disable Metrics/AbcSize
      def create_procurement_row(procurement)
        [
          procurement.contract_number,
          procurement.contract_name,
          localised_datetime(procurement.created_at),
          procurement.user.buyer_detail.organisation_name,
          procurement.user.buyer_detail.full_organisation_address,
          procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
          procurement.user.buyer_detail.full_name,
          procurement.user.buyer_detail.job_title, # 10
          procurement.user.email,
          string_as_formula(procurement.user.buyer_detail.telephone_number),
          expand_services(procurement.service_codes),
          expand_regions(procurement.region_codes),
          delimited_contract_value(procurement.annual_contract_value),
          procurement.lot_number,
          shortlisted_suppliers(procurement)
        ]
      end
      # rubocop:enable Metrics/AbcSize

      def date_to_string(date)
        date&.in_time_zone('London')&.strftime '%Y%m%d'
      end

      def created_at
        @management_report.created_at&.in_time_zone('London')&.strftime '%Y%m%d-%H%M'
      end

      def localised_datetime(datetime)
        datetime.in_time_zone(TIME_ZONE).strftime(TIME_FORMAT)
      end

      def string_as_formula(string)
        return if string.blank?

        "=\"#{string}\""
      end

      def expand_services(service_codes)
        return if service_codes.blank?

        service_codes.compact.map do |code|
          "#{code} #{service_names[code] || 'service description not found'};\n"
        end.join
      end

      def service_names
        @service_names ||= FacilitiesManagement::RM6232::Service.pluck(:code, :name).to_h
      end

      def expand_regions(region_codes)
        return if region_codes.blank?

        region_codes.compact.map do |code|
          "#{code} #{region_names[code] || 'region description not found'};\n"
        end.join
      end

      def region_names
        @region_names ||= FacilitiesManagement::Region.all.map { |region| [region.code, region.name] }.to_h
      end

      def delimited_contract_value(value)
        return if value.blank?

        helpers.number_with_precision(value, precision: 2, delimiter: ',')
      end

      def shortlisted_suppliers(procurement)
        procurement.supplier_names.join(LIST_ITEM_SEPARATOR)
      end

      def helpers
        @helpers ||= ActionController::Base.helpers
      end

      COLUMN_LABELS = [
        'Reference number',
        'Contract name',
        'Date created',
        'Buyer organisation',
        'Buyer organisation address',
        'Buyer sector',
        'Buyer contact name',
        'Buyer contact job title',
        'Buyer contact email address',
        'Buyer contact telephone number',
        'Services',
        'Regions',
        'Annual contract cost',
        'Lot',
        'Shortlisted Suppliers'
      ].freeze

      TIME_FORMAT = '%e %B %Y, %l:%M%P'.freeze
      TIME_ZONE = 'London'.freeze
      LIST_ITEM_SEPARATOR = ";\n".freeze
    end
  end
end
