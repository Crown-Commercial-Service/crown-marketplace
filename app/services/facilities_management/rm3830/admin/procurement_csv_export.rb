module FacilitiesManagement::RM3830
  class Admin::ProcurementCsvExport
    TIME_FORMAT = '%e %B %Y, %l:%M%P'.freeze
    DATE_FORMAT = '%e %B %Y'.freeze
    TIME_ZONE = 'London'.freeze
    LIST_ITEM_SEPARATOR = ";\n".freeze

    # TODO: These should probably be under I18n in en.yml
    STATE_DESCRIPTIONS = {
      # Procurement
      'quick_search' => 'Quick view',
      'detailed_search' => 'Entering requirements',
      'detailed_search_bulk_upload' => 'Entering requirements',
      'choose_contract_value' => 'Choose contract value',
      'results' => 'Results',
      'da_draft' => 'DA draft',
      'direct_award' => 'Direct award',
      'further_competition' => 'FC',
      'closed' => 'DA closed',

      # Procurement supplier (DA contract)
      'sent' => 'DA sent',
      'declined' => 'DA declined',
      'expired' => 'DA expired', # In the example spreadsheet this was 'DA not responded'
      'accepted' => 'DA accepted, awaiting contract signature', # In the example spreadsheet there was an extra state 'DA awaiting contract signature'
      'signed' => 'DA signed (contract)',
      'not_signed' => 'DA not signed'
    }.freeze

    EARLY_STATES = %w[quick_search detailed_search detailed_search_bulk_upload].freeze

    SPREADSHEET_IMPORT_STATE_DESCRIPTIONS = {
      'importing' => 'In progress',
      'failed' => 'Failed',
      'succeeded' => 'Completed'
    }.freeze

    # TODO: These should probably be under I18n in en.yml
    COLUMN_LABELS = [
      'Contract name',
      'Date created',
      'Date last updated',
      'Stage/Status',
      'Upload status', # 5
      'Buyer organisation',
      'Buyer organisation address',
      'Buyer sector',
      'Buyer contact name',
      'Buyer contact job title', # 10
      'Buyer contact email address',
      'Buyer contact telephone number',
      'Quick view services',
      'Quick view regions',
      'Customer Estimated Contract Value (GBP)', # 15
      'Tupe involved',
      'Initial call-off - period length, start date, end date',
      'Mobilisation - period length, start date, end date',
      'Optional call-off extensions',
      'Number of Buildings', # 20
      'Building Types',
      'Building services',
      'Building GIA sum total',
      'Building external area sum total',
      'Building regions', # 25
      'Assessed Value (GBP)',
      'Recommended Sub-lot',
      'Eligible for DA',
      'Shortlisted Suppliers',
      'Unpriced services', # 30
      'Route to market selected',
      'DA Suppliers (ranked)',
      'DA Suppliers costs (GBP ranked)',
      'DA Awarded Supplier',
      'DA Awarded Supplier cost (GBP)', # 35
      'Contract number',
      'DA Supplier decline reason',
      'DA Buyer withdraw reason',
      'DA Buyer not-sign reason',
      'DA Buyer contract signed/not-signed date', # 40
      'DA Buyer confirmed contract dates'
    ].freeze

    def self.call(start_date, end_date)
      CSV.generate do |csv|
        csv << COLUMN_LABELS
        find_contracts(start_date, end_date).each { |contract| csv << create_contract_row(contract) }
        find_procurements(start_date, end_date).each { |procurement| csv << create_procurement_row(procurement) }
      end
    end

    # rubocop:disable Metrics/AbcSize
    def self.create_contract_row(contract)
      procurement = contract.procurement
      [
        procurement.contract_name,
        localised_datetime(procurement.created_at),
        contract.unsent? ? localised_datetime(procurement.updated_at) : localised_datetime(contract.updated_at),
        procurement_status(procurement, contract),
        spreadsheet_import_status(procurement), # 5
        procurement.user.buyer_detail.organisation_name,
        [procurement.user.buyer_detail.organisation_address_line_1, procurement.user.buyer_detail.organisation_address_line_2, procurement.user.buyer_detail.organisation_address_town, procurement.user.buyer_detail.organisation_address_county, procurement.user.buyer_detail.organisation_address_postcode].join(', '),
        procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
        procurement.user.buyer_detail.full_name,
        procurement.user.buyer_detail.job_title, # 10
        procurement.user.email,
        string_as_formula(procurement.user.buyer_detail.telephone_number),
        expand_services(procurement.service_codes),
        expand_regions(procurement.region_codes),
        estimated_annual_cost(procurement), # 15
        yes_no(procurement.tupe),
        format_period_start_end(procurement),
        mobilisation_period(procurement),
        call_off_extensions(procurement),
        blank_if_zero(procurement.active_procurement_buildings.size), # 20
        building_types(procurement),
        expand_services_and_standards(procurement.procurement_building_service_codes_and_standards),
        building_gias(procurement),
        building_total_external_area(procurement),
        expand_regions(procurement.active_procurement_buildings_with_attribute_distinct(:address_region_code)), # 25
        delimited_with_pence(procurement.assessed_value),
        format_lot_number(procurement.lot_number),
        yes_no(procurement.eligible_for_da),
        shortlisted_suppliers(procurement),
        expand_services_and_standards(unpriced_services(procurement.procurement_building_service_codes_and_standards)), # 30
        route_to_market(procurement),
        da_suppliers(procurement),
        da_suppliers_costs(procurement),
        supplier_names[contract.supplier_id],
        delimited_with_pence(contract.direct_award_value), # 35
        contract.contract_number,
        contract.reason_for_declining,
        contract.reason_for_closing,
        contract.reason_for_not_signing,
        localised_date(contract.contract_signed_date), # 40
        [localised_date(contract.contract_start_date), localised_date(contract.contract_end_date)].compact.join(' - ')
      ]
    end

    def self.create_procurement_row(procurement)
      [
        procurement.contract_name,
        localised_datetime(procurement.created_at),
        localised_datetime(procurement.updated_at),
        procurement_status(procurement, nil),
        spreadsheet_import_status(procurement), # 5
        procurement.user.buyer_detail.organisation_name,
        [procurement.user.buyer_detail.organisation_address_line_1, procurement.user.buyer_detail.organisation_address_line_2, procurement.user.buyer_detail.organisation_address_town, procurement.user.buyer_detail.organisation_address_county, procurement.user.buyer_detail.organisation_address_postcode].join(', '),
        procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
        procurement.user.buyer_detail.full_name,
        procurement.user.buyer_detail.job_title, # 10
        procurement.user.email,
        string_as_formula(procurement.user.buyer_detail.telephone_number),
        expand_services(procurement.service_codes),
        expand_regions(procurement.region_codes),
        estimated_annual_cost(procurement), # 15
        yes_no(procurement.tupe),
        format_period_start_end(procurement),
        mobilisation_period(procurement),
        call_off_extensions(procurement),
        blank_if_zero(procurement.active_procurement_buildings.size), # 20
        building_types(procurement),
        expand_services_and_standards(procurement.procurement_building_service_codes_and_standards),
        building_gias(procurement),
        building_total_external_area(procurement),
        expand_regions(procurement.active_procurement_buildings_with_attribute_distinct(:address_region_code)), # 25
        delimited_with_pence(procurement.assessed_value),
        format_lot_number(procurement.lot_number),
        yes_no(procurement.eligible_for_da),
        shortlisted_suppliers(procurement),
        EARLY_STATES.include?(procurement.aasm_state) ? nil : expand_services_and_standards(unpriced_services(procurement.procurement_building_service_codes_and_standards)), # 30
        route_to_market(procurement),
        procurement.eligible_for_da? ? da_suppliers(procurement) : nil,
        procurement.eligible_for_da? ? da_suppliers_costs(procurement) : nil,
        nil,
        nil, # 35
        procurement.further_competition? ? procurement.contract_number : nil,
        nil,
        nil,
        nil,
        nil, # 40
        nil
      ]
    end
    # rubocop:enable Metrics/AbcSize

    CONTRACT_BEARING_STATES = %w[direct_award closed].freeze

    def self.find_contracts(start_date, end_date)
      ProcurementSupplier
        .where(updated_at: (start_date..(end_date + 1)))
        .where.not(aasm_state: 'unsent')
        .select { |contract| CONTRACT_BEARING_STATES.include?(contract.procurement.aasm_state) }
    end

    def self.find_procurements(start_date, end_date)
      Procurement
        .where(updated_at: (start_date..(end_date + 1)))
        .where.not(aasm_state: CONTRACT_BEARING_STATES)
    end

    def self.procurement_status(procurement, contract = nil)
      return STATE_DESCRIPTIONS[procurement.aasm_state] if procurement.closed?

      contract ? STATE_DESCRIPTIONS[contract.aasm_state] : STATE_DESCRIPTIONS[procurement.aasm_state]
    end

    def self.yes_no(flag)
      return 'Yes' if flag.instance_of?(TrueClass)
      return 'No' if flag.instance_of?(FalseClass)

      ''
    end

    def self.helpers
      ActionController::Base.helpers
    end

    def self.expand_services(service_codes)
      return if service_codes.nil?

      service_codes.compact.map do |code|
        "#{code} #{service_codes_with_name[code] || 'service description not found'};\n"
      end.join
    end

    def self.service_codes_with_name
      @service_codes_with_name ||= Service.all.to_h { |service| [service.code, service.name] }
    end

    def self.expand_services_and_standards(list)
      return if list.nil?

      list.compact.sort_by(&:join).map do |code, standard|
        [
          "#{code} #{service_codes_with_name[code] || 'service description not found'}",
          standard.present? ? " - Standard #{standard}" : '',
          LIST_ITEM_SEPARATOR
        ].join
      end.join
    end

    def self.expand_regions(region_codes)
      return if region_codes.nil?

      region_codes.compact.map do |code|
        "#{code} #{regions_with_name[code] || 'region description not found'};\n"
      end.join
    end

    def self.regions_with_name
      @regions_with_name ||= FacilitiesManagement::Region.all.to_h { |region| [region.code, region.name] }
    end

    def self.unpriced_services(list)
      list.select do |service_code, standard|
        rate = ccs_fm_rates[[service_code, standard]]
        rate.nil? ? false : (rate[:framework].nil? || rate[:benchmark].nil?)
      end
    end

    def self.ccs_fm_rates
      @ccs_fm_rates ||= Rate.select(:code, :standard, :framework, :benchmark)
                            .to_h { |rate| [[rate.code, rate.standard], { framework: rate.framework, benchmark: rate.benchmark }] }
    end

    def self.format_period_start_end(procurement)
      return '' if procurement.unanswered_contract_date_questions?

      "#{initial_call_off_period(procurement)}, " +
        [procurement.initial_call_off_start_date.strftime(DATE_FORMAT),
         procurement.initial_call_off_end_date.strftime(DATE_FORMAT)].join(' - ')
    end

    def self.call_off_extensions(procurement)
      return '' if procurement.extensions_required.nil?
      return 'None' unless procurement.extensions_required

      return '' if procurement.call_off_extensions.none?

      "#{helpers.pluralize(procurement.call_off_extensions.count, 'extension')}, " +
        procurement.call_off_extensions.sorted.map { |ext| period_to_string(ext.years, ext.months) }.join(', ')
    end

    def self.format_lot_number(lot_number)
      return '' if lot_number.blank?

      "Sub-lot #{lot_number}"
    end

    def self.localised_datetime(datetime)
      return '' if datetime.blank?

      datetime.in_time_zone(TIME_ZONE).strftime(TIME_FORMAT)
    end

    def self.localised_date(datetime)
      return '' if datetime.blank?

      datetime.in_time_zone(TIME_ZONE).strftime(DATE_FORMAT)
    end

    # This is a hack to force spreadsheet programs to import the string as a formula.
    #   E.g: '="07882898978"'
    #
    # This will preserve leading zeros in telephone numbers.
    # Works in Apple Numbers - tested.
    # Works in Microsoft Excel - tested.
    def self.string_as_formula(string)
      return nil if string.blank?

      "=\"#{string}\""
    end

    def self.delimited_with_pence(val)
      return nil if val.blank?

      helpers.number_with_precision(val, precision: 2, delimiter: ',')
    end

    def self.route_to_market(procurement)
      return 'Further Competition' if procurement.further_competition?
      return 'Direct Award' if %w[da_draft direct_award closed].include?(procurement.aasm_state)

      nil
    end

    def self.blank_if_zero(val)
      val.to_i.positive? ? val : ''
    end

    def self.estimated_annual_cost(procurement)
      return '' if procurement.estimated_cost_known.nil?

      procurement.estimated_cost_known ? delimited_with_pence(procurement.estimated_annual_cost) : 'None'
    end

    def self.initial_call_off_period(procurement)
      period_to_string(procurement.initial_call_off_period_years, procurement.initial_call_off_period_months)
    end

    def self.mobilisation_period(procurement)
      return '' if procurement.mobilisation_period_required.nil?
      return 'None' if !procurement.mobilisation_period_required || procurement.mobilisation_period.nil?

      "#{helpers.pluralize(procurement.mobilisation_period, 'weeks')}, " +
        [procurement.mobilisation_start_date.strftime(DATE_FORMAT),
         procurement.mobilisation_end_date.strftime(DATE_FORMAT)].join(' - ')
    end

    def self.period_to_string(years, months)
      years_text = years.positive? ? helpers.pluralize(years, 'year') : nil
      months_text = months.positive? ? helpers.pluralize(months, 'month') : nil

      [years_text, months_text].compact.join(' and ')
    end

    def self.da_suppliers(procurement)
      procurement.procurement_suppliers.sort_by(&:direct_award_value)
                 .map { |s| supplier_names[s.supplier_id] }.join(LIST_ITEM_SEPARATOR)
    end

    def self.da_suppliers_costs(procurement)
      procurement.procurement_suppliers.sort_by(&:direct_award_value)
                 .map { |s| delimited_with_pence(s.direct_award_value) }.join(LIST_ITEM_SEPARATOR)
    end

    def self.shortlisted_suppliers(procurement)
      procurement.procurement_suppliers.map { |s| supplier_names[s.supplier_id] }.join(LIST_ITEM_SEPARATOR)
    end

    def self.building_types(procurement)
      procurement.active_procurement_buildings_with_attribute_distinct(:building_type).join(LIST_ITEM_SEPARATOR)
    end

    def self.building_gias(procurement)
      procurement.active_procurement_buildings_with_attribute(:gia).map(&:to_i).reduce(0, :+)
    end

    def self.building_total_external_area(procurement)
      procurement.active_procurement_buildings_with_attribute(:external_area).map(&:to_i).reduce(0, :+)
    end

    def self.spreadsheet_import_status(procurement)
      return nil unless procurement.spreadsheet_import

      SPREADSHEET_IMPORT_STATE_DESCRIPTIONS[procurement.spreadsheet_import.aasm_state]
    end

    def self.supplier_names
      @supplier_names ||= SupplierDetail.all.select(:supplier_id, :supplier_name).pluck(:supplier_id, :supplier_name).to_h
    end
  end
end
