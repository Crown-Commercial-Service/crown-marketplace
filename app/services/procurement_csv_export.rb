class ProcurementCsvExport
  TIME_FORMAT = '%e %B %Y, %l:%M%P'.freeze
  DATE_FORMAT = '%e %B %Y'.freeze
  TIME_ZONE = 'London'.freeze

  # TODO: These should probably be under I18n in en.yml
  STATE_DESCRIPTIONS = {
    # Procurement
    'quick_search' => 'Quick search',
    'detailed_search' => 'Detailed search',
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

  # TODO: These should probably be under I18n in en.yml
  COLUMN_LABELS = [
    'Contract name',
    'Date created',
    'Date last updated',
    'Stage/Status',
    'Buyer organisation',
    'Buyer organisation address',
    'Buyer sector',
    'Buyer contact name',
    'Buyer contact job title',
    'Buyer contact email address',
    'Buyer contact telephone number',
    'Quick search services',
    'Quick search regions',
    'Customer Estimated Contract Value (GBP)',
    'Tupe involved',
    'Initial call-off - period length, start date, end date',
    'Mobilisation - period length, start date, end date',
    'Optional call-off extensions',
    'Number of Buildings',
    'Services',
    'Building regions',
    'Assessed Value (GBP)',
    'Recommended Sub-lot',
    'Eligible for DA',
    'Shortlisted Suppliers',
    'Unpriced services',
    'Route to market selected',
    'DA Suppliers (ranked)',
    'DA Suppliers costs (GBP ranked)',
    'DA Awarded Supplier',
    'DA Awarded Supplier cost (GBP)',
    'Contract number',
    'DA Supplier decline reason',
    'DA Buyer withdraw reason',
    'DA Buyer not-sign reason',
    'DA Buyer contract signed/not-signed date',
    'DA Buyer confirmed contract dates'
  ].freeze

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def self.call(start_date, end_date)
    # rubocop:disable Metrics/BlockLength
    CSV.generate do |csv|
      csv << COLUMN_LABELS

      find_contracts(start_date, end_date).each do |contract|
        csv << [
          contract.procurement.contract_name,
          localised_datetime(contract.procurement.created_at),
          contract.unsent? ? localised_datetime(contract.procurement.updated_at) : localised_datetime(contract.updated_at),
          procurement_status(contract.procurement, contract),
          contract.procurement.user.buyer_detail.organisation_name,
          [contract.procurement.user.buyer_detail.organisation_address_line_1, contract.procurement.user.buyer_detail.organisation_address_line_2, contract.procurement.user.buyer_detail.organisation_address_town, contract.procurement.user.buyer_detail.organisation_address_county, contract.procurement.user.buyer_detail.organisation_address_postcode].join(', '),
          contract.procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
          contract.procurement.user.buyer_detail.full_name,
          contract.procurement.user.buyer_detail.job_title,
          contract.procurement.user.email,
          string_as_formula(contract.procurement.user.buyer_detail.telephone_number),
          expand_services(contract.procurement.service_codes),
          expand_regions(contract.procurement.region_codes),
          delimited_with_pence(contract.procurement.estimated_annual_cost),
          yes_no(contract.procurement.tupe),
          format_period_start_end(contract.procurement),
          format_mobilisation_start_end(contract.procurement),
          call_off_extensions(contract.procurement),
          blank_if_zero(contract.procurement.active_procurement_buildings.size),
          expand_services(contract.procurement.procurement_building_service_codes),
          expand_regions(contract.procurement.active_procurement_building_region_codes),
          delimited_with_pence(contract.procurement.assessed_value),
          format_lot_number(contract.procurement.lot_number),
          yes_no(contract.procurement.eligible_for_da),
          contract.procurement.procurement_suppliers.map { |s| s.supplier.data['supplier_name'] } .join(",\n"),
          expand_services(unpriced_services(contract.procurement.procurement_building_service_codes)),
          route_to_market(contract.procurement),
          contract.procurement.procurement_suppliers.sort_by(&:direct_award_value) .map { |s| s.supplier.data['supplier_name'] } .join("\n"),
          contract.procurement.procurement_suppliers.sort_by(&:direct_award_value) .map { |s| helpers.delimited_with_pence(s.direct_award_value) } .join("\n"),
          contract.supplier.data['supplier_name'],
          delimited_with_pence(contract.direct_award_value),
          contract.contract_number,
          contract.reason_for_declining,
          contract.reason_for_closing,
          contract.reason_for_not_signing,
          localised_date(contract.contract_signed_date),
          [localised_date(contract.contract_start_date), localised_date(contract.contract_end_date)].compact.join(' - ')
        ]
      end

      find_procurements(start_date, end_date).each do |procurement|
        csv << [
          procurement.contract_name,
          localised_datetime(procurement.created_at),
          localised_datetime(procurement.updated_at),
          procurement_status(procurement, nil),
          procurement.user.buyer_detail.organisation_name,
          [procurement.user.buyer_detail.organisation_address_line_1, procurement.user.buyer_detail.organisation_address_line_2, procurement.user.buyer_detail.organisation_address_town, procurement.user.buyer_detail.organisation_address_county, procurement.user.buyer_detail.organisation_address_postcode].join(', '),
          procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
          procurement.user.buyer_detail.full_name,
          procurement.user.buyer_detail.job_title,
          procurement.user.email,
          string_as_formula(procurement.user.buyer_detail.telephone_number),
          expand_services(procurement.service_codes),
          expand_regions(procurement.region_codes),
          delimited_with_pence(procurement.estimated_annual_cost),
          yes_no(procurement.tupe),
          format_period_start_end(procurement),
          format_mobilisation_start_end(procurement),
          call_off_extensions(procurement),
          blank_if_zero(procurement.active_procurement_buildings.size),
          expand_services(procurement.procurement_building_service_codes),
          expand_regions(procurement.active_procurement_building_region_codes),
          delimited_with_pence(procurement.assessed_value),
          format_lot_number(procurement.lot_number),
          yes_no(procurement.eligible_for_da),
          nil,
          expand_services(unpriced_services(procurement.procurement_building_service_codes)),
          route_to_market(procurement),
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil
        ]
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  CONTRACT_BEARING_STATES = %w[direct_award closed].freeze

  def self.find_contracts(start_date, end_date)
    FacilitiesManagement::ProcurementSupplier
      .includes(procurement: [user: :buyer_detail])
      .includes(procurement: :active_procurement_buildings)
      .includes(procurement: :procurement_building_services)
      .where(updated_at: (start_date..(end_date + 1)))
      .where.not(aasm_state: 'unsent')
      .select { |contract| CONTRACT_BEARING_STATES.include?(contract.procurement.aasm_state) }
  end

  def self.find_procurements(start_date, end_date)
    FacilitiesManagement::Procurement
      .includes(user: :buyer_detail)
      .includes(:active_procurement_buildings)
      .includes(:procurement_building_services)
      .where(updated_at: (start_date..(end_date + 1)))
      .where.not(aasm_state: CONTRACT_BEARING_STATES)
  end

  def self.procurement_status(procurement, contract = nil)
    return STATE_DESCRIPTIONS[procurement.aasm_state] if procurement.closed?

    contract ? STATE_DESCRIPTIONS[contract.aasm_state] : STATE_DESCRIPTIONS[procurement.aasm_state]
  end

  def self.yes_no(flag)
    return 'Yes' if flag.class == TrueClass
    return 'No' if flag.class == FalseClass

    ''
  end

  def self.helpers
    ActionController::Base.helpers
  end

  def self.expand_services(service_codes)
    service_codes.compact.map do |code|
      "#{code} #{FacilitiesManagement::Service.find_by(code: code)&.name || 'service description not found'};\n"
    end.join
  end

  def self.expand_regions(region_codes)
    region_codes.compact.map do |code|
      "#{code} #{FacilitiesManagement::Region.find_by(code: code)&.name || 'region description not found'};\n"
    end.join
  end

  def self.unpriced_services(service_codes)
    service_codes.select do |service_code|
      CCS::FM::Rate.framework_rate_for(service_code).nil? || CCS::FM::Rate.benchmark_rate_for(service_code).nil?
    end
  end

  def self.format_period_start_end(procurement)
    return '' if procurement.unanswered_contract_date_questions?

    "#{procurement.initial_call_off_period} years, " +
      [procurement.initial_call_off_start_date.strftime(DATE_FORMAT),
       procurement.initial_call_off_end_date.strftime(DATE_FORMAT)].join(' - ')
  end

  def self.format_mobilisation_start_end(procurement)
    return '' if procurement.mobilisation_period.nil?

    "#{procurement.mobilisation_period} weeks, " +
      [procurement.mobilisation_period_start_date.strftime(DATE_FORMAT),
       procurement.mobilisation_period_end_date.strftime(DATE_FORMAT)].join(' - ')
  end

  def self.call_off_extensions(procurement)
    extensions = [
      procurement.optional_call_off_extensions_1,
      procurement.optional_call_off_extensions_2,
      procurement.optional_call_off_extensions_3,
      procurement.optional_call_off_extensions_4
    ].compact

    return nil if extensions.none?

    "#{helpers.pluralize(extensions.size, 'extension')}, " +
      extensions.map { |ext| helpers.pluralize(ext, 'year') } .join(', ')
  end

  def self.format_lot_number(lot_number)
    return '' if lot_number.blank?

    'Sub-lot ' + lot_number
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
  # Works in Microsoft Excel according to:
  #   https://stackoverflow.com/questions/308324/csv-for-excel-including-both-leading-zeros-and-commas
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
end
