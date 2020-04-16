class ProcurementCsvExport
  TIME_FORMAT = '%e %B %Y, %l:%M%P'.freeze
  DATE_FORMAT = '%e %B %Y'.freeze

  # TODO: These should probably be under I18n in en.yml
  STATE_DESCRIPTIONS = {
    # Procurement
    'quick_search' => 'Quick search',
    'detailed_search' => 'Detailed search',
    'results' => 'Results',
    'da_draft' => 'DA draft',
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
    '', # Separator column
    'Buyer organisation',
    'Buyer organisation address',
    'Buyer sector',
    'Buyer contact name',
    'Buyer contact job title',
    'Buyer contact email address',
    'Buyer contact telephone number',
    'Quick search services',
    'Quick search regions',
    'Customer Estimated Contract Value',
    'Tupe involved',
    'Initial call-off - period length, start date, end date',
    'Mobilisation - period length, start date, end date',
    'Optional call-off extensions',
    'Number of Buildings',
    'Services',
    'Building regions',
    'Assessed Value',
    'Recommended Sub-lot',
    'Eligible for DA',
    'Shortlisted Suppliers',
    'Unpriced services',
    'Route to market selected',
    'DA Suppliers (ranked)',
    'DA Suppliers costs (ranked)',
    'DA Awarded Supplier',
    'DA Awarded Supplier cost',
    'Contract number',
    'DA Supplier decline reason',
    'DA Buyer withdraw reason',
    'DA Buyer not-sign reason',
    'DA Buyer contract signed date',
    'DA Buyer confirmed contract dates'
  ].freeze

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def self.call
    # rubocop:disable Metrics/BlockLength
    CSV.generate do |csv|
      csv << COLUMN_LABELS

      find_contracts.each do |contract|
        csv << [
          contract.procurement.contract_name,
          contract.procurement.created_at.strftime(TIME_FORMAT),
          contract.unsent? ? contract.procurement.updated_at.strftime(TIME_FORMAT) : contract.updated_at.strftime(TIME_FORMAT),
          procurement_status(contract.procurement, contract),
          nil, # Separator column
          contract.procurement.user.buyer_detail.organisation_name,
          [contract.procurement.user.buyer_detail.organisation_address_line_1, contract.procurement.user.buyer_detail.organisation_address_line_2, contract.procurement.user.buyer_detail.organisation_address_town, contract.procurement.user.buyer_detail.organisation_address_county, contract.procurement.user.buyer_detail.organisation_address_postcode].join(', '),
          contract.procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
          contract.procurement.user.buyer_detail.full_name,
          contract.procurement.user.buyer_detail.job_title,
          contract.procurement.user.email,
          contract.procurement.user.buyer_detail.telephone_number,
          expand_services(contract.procurement.procurement_building_service_codes),
          expand_regions(contract.procurement.active_procurement_building_region_codes),
          helpers.number_to_currency(contract.procurement.estimated_annual_cost),
          yes_no(contract.procurement.tupe),
          format_period_start_end(contract.procurement),
          format_mobilisation_start_end(contract.procurement),
          call_off_extensions(contract.procurement),
          contract.procurement.active_procurement_buildings.size,
          expand_services(contract.procurement.procurement_building_service_codes),
          expand_regions(contract.procurement.active_procurement_building_region_codes),
          helpers.number_to_currency(contract.procurement.assessed_value),
          'Sub-lot ' + contract.procurement.lot_number,
          yes_no(contract.procurement.eligible_for_da),
          contract.procurement.procurement_suppliers.map { |s| s.supplier.data['supplier_name'] } .join(",\n"),
          expand_services(unpriced_services(contract.procurement.procurement_building_service_codes)),
          contract.procurement.route_to_market,
          contract.procurement.procurement_suppliers.sort_by(&:direct_award_value) .map { |s| s.supplier.data['supplier_name'] } .join("\n"),
          contract.procurement.procurement_suppliers.sort_by(&:direct_award_value) .map { |s| helpers.number_to_currency(s.direct_award_value) } .join("\n"),
          contract.supplier.data['supplier_name'],
          helpers.number_to_currency(contract.direct_award_value),
          contract.contract_number,
          contract.reason_for_declining,
          contract.reason_for_closing,
          contract.reason_for_not_signing,
          contract.contract_signed_date.strftime(DATE_FORMAT),
          "#{contract.contract_start_date.strftime(DATE_FORMAT)} - #{contract.contract_end_date.strftime(DATE_FORMAT)}"
        ]
      end

      find_procurements.each do |procurement|
        csv << [
          procurement.contract_name,
          procurement.created_at.strftime(TIME_FORMAT),
          procurement.updated_at.strftime(TIME_FORMAT),
          procurement_status(procurement, nil),
          nil, # Separator column
          procurement.user.buyer_detail.organisation_name,
          [procurement.user.buyer_detail.organisation_address_line_1, procurement.user.buyer_detail.organisation_address_line_2, procurement.user.buyer_detail.organisation_address_town, procurement.user.buyer_detail.organisation_address_county, procurement.user.buyer_detail.organisation_address_postcode].join(', '),
          procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
          procurement.user.buyer_detail.full_name,
          procurement.user.buyer_detail.job_title,
          procurement.user.email,
          procurement.user.buyer_detail.telephone_number,
          expand_services(procurement.procurement_building_service_codes),
          expand_regions(procurement.active_procurement_building_region_codes),
          helpers.number_to_currency(procurement.estimated_annual_cost),
          yes_no(procurement.tupe),
          format_period_start_end(procurement),
          format_mobilisation_start_end(procurement),
          call_off_extensions(procurement),
          procurement.active_procurement_buildings.size,
          expand_services(procurement.procurement_building_service_codes),
          expand_regions(procurement.active_procurement_building_region_codes),
          helpers.number_to_currency(procurement.assessed_value),
          'Sub-lot ' + procurement.lot_number,
          yes_no(procurement.eligible_for_da),
          nil,
          expand_services(unpriced_services(procurement.procurement_building_service_codes)),
          procurement.route_to_market,
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

  def self.find_contracts
    FacilitiesManagement::ProcurementSupplier
      .joins(:procurement)
      .where("facilities_management_procurements.aasm_state = 'direct_award'")
      .where("facilities_management_procurement_suppliers.aasm_state != 'unsent'")
  end

  def self.find_procurements
    FacilitiesManagement::Procurement
      .includes(:procurement_suppliers)
      .where("facilities_management_procurements.aasm_state != 'direct_award'")
  end

  def self.procurement_status(procurement, contract = nil)
    if procurement.direct_award?
      STATE_DESCRIPTIONS[contract.aasm_state]
    else
      STATE_DESCRIPTIONS[procurement.aasm_state]
    end
  end

  def self.yes_no(flag)
    flag ? 'Yes' : 'No'
  end

  def self.helpers
    ActionController::Base.helpers
  end

  def self.expand_services(service_codes)
    service_codes.map { |code| "#{code} #{FacilitiesManagement::Service.find_by(code: code).name};\n" } .join
  end

  def self.expand_regions(region_codes)
    region_codes.map { |code| "#{code} #{FacilitiesManagement::Region.find_by(code: code).name};\n" } .join
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
    list = [
      procurement.optional_call_off_extensions_1,
      procurement.optional_call_off_extensions_2,
      procurement.optional_call_off_extensions_3,
      procurement.optional_call_off_extensions_4
    ].compact

    return nil if list.none?

    "#{list.size} extensions, " + list.join(', ')
  end
end
