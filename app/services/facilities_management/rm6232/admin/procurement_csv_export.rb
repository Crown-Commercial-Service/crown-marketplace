module FacilitiesManagement::RM6232
  class Admin::ProcurementCsvExport
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
      'Buyer opted in to be contacted',
      'Services',
      'Regions',
      'Annual contract cost',
      'Lot',
      'Shortlisted Suppliers'
    ].freeze

    TIME_FORMAT = '%e %B %Y, %l:%M%P'.freeze
    TIME_ZONE = 'London'.freeze
    LIST_ITEM_SEPARATOR = ";\n".freeze

    def self.call(start_date, end_date)
      CSV.generate do |csv|
        csv << COLUMN_LABELS
        find_procurements(start_date, end_date).each { |procurement| csv << create_procurement_row(procurement) }
      end
    end

    def self.find_procurements(start_date, end_date)
      Procurement.where(created_at: (start_date..(end_date + 1))).where.not(user_id: test_user_ids).order(created_at: :desc)
    end

    # rubocop:disable Metrics/AbcSize
    def self.create_procurement_row(procurement)
      [
        procurement.contract_number,
        procurement.contract_name,
        localised_datetime(procurement.created_at),
        procurement.user.buyer_detail.organisation_name,
        procurement.user.buyer_detail.full_organisation_address,
        procurement.user.buyer_detail.sector_name,
        procurement.user.buyer_detail.contact_opt_in ? procurement.user.buyer_detail.full_name : '',
        procurement.user.buyer_detail.job_title,
        procurement.user.buyer_detail.contact_opt_in ? procurement.user.email : '',
        procurement.user.buyer_detail.contact_opt_in ? string_as_formula(procurement.user.buyer_detail.telephone_number) : '',
        procurement.user.buyer_detail.contact_opt_in ? 'Yes' : 'No',
        expand_services(procurement.service_codes),
        expand_regions(procurement.region_codes),
        delimited_contract_value(procurement.annual_contract_value),
        procurement.lot_number,
        shortlisted_suppliers(procurement)
      ]
    end
    # rubocop:enable Metrics/AbcSize

    def self.localised_datetime(datetime)
      datetime.in_time_zone(TIME_ZONE).strftime(TIME_FORMAT)
    end

    def self.string_as_formula(string)
      return if string.blank?

      "=\"#{string}\""
    end

    def self.expand_services(service_codes)
      return if service_codes.blank?

      service_codes.compact.map do |code|
        "#{code} #{service_names[code] || 'service description not found'};\n"
      end.join
    end

    def self.service_names
      @service_names ||= FacilitiesManagement::RM6232::Service.pluck(:code, :name).to_h
    end

    def self.expand_regions(region_codes)
      return if region_codes.blank?

      region_codes.compact.map do |code|
        "#{code} #{region_names[code] || 'region description not found'};\n"
      end.join
    end

    def self.region_names
      @region_names ||= FacilitiesManagement::Region.all.to_h { |region| [region.code, region.name] }
    end

    def self.delimited_contract_value(value)
      return if value.blank?

      helpers.number_with_precision(value, precision: 2, delimiter: ',')
    end

    def self.shortlisted_suppliers(procurement)
      procurement.supplier_names.join(LIST_ITEM_SEPARATOR)
    end

    def self.helpers
      @helpers ||= ActionController::Base.helpers
    end

    def self.test_user_ids
      User.where(email: ENV.fetch('TEST_USER_EMAILS', '').split(',')).pluck(:id)
    end
  end
end
