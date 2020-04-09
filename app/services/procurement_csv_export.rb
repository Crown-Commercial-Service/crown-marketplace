class ProcurementCsvExport
  def self.call
    CSV.generate do |csv|
      first = true
      FacilitiesManagement::ProcurementSupplier.joins(:procurement).where("facilities_management_procurement_suppliers.aasm_state != 'unsent'").all.each do |contract|
        row = {
          'Contract name' => contract.procurement.contract_name,
          'Date created' => contract.procurement.created_at.to_date,
          'Date updated' => contract.procurement.updated_at.to_date,
          'Status' => contract.procurement.aasm_state,
          'Buyer organisation' => contract.procurement.user.buyer_detail.organisation_name,
          'Buyer organisation_address' => [contract.procurement.user.buyer_detail.organisation_address_line_1, contract.procurement.user.buyer_detail.organisation_address_line_2, contract.procurement.user.buyer_detail.organisation_address_town, contract.procurement.user.buyer_detail.organisation_address_county, contract.procurement.user.buyer_detail.organisation_address_postcode].join(', '),
          'Buyer sector' => contract.procurement.user.buyer_detail.central_government ? 'Central government' : 'Wider public sector',
          'Buyer contact name' => contract.procurement.user.buyer_detail.full_name,
          'Buyer contact job title' => contract.procurement.user.buyer_detail.job_title,
          'Buyer contact email address' => contract.procurement.user.email,
          'Buyer contact telephone number' => contract.procurement.user.buyer_detail.telephone_number,
          'Quick search services' => contract.procurement.service_codes.join(",\n"),
          'Quick search regions' => contract.procurement.region_codes.join(",\n"),
          'Customer Estimated Contract Value' => contract.procurement.estimated_annual_cost,
          'Tupe involved' => contract.procurement.tupe,
          'Initial call-off - period length, start date, end date' => format_period_start_end(contract.procurement),
          'Mobilisation - period length, start date, end date' => format_mobilisation_start_end(contract.procurement),
          'Optional call-off extensions' => call_off_extensions(contract.procurement),
          'Number of Buildings' => contract.procurement.procurement_buildings.size,
          'Services' => contract.procurement.service_codes.join(",\n"),
          'Building regions' => contract.procurement.region_codes.join(",\n"),
          'Assessed Value' => contract.procurement.assessed_value,
          'Recommended Sub-lot' => contract.procurement.lot_number,
          'Eligible for DA' => contract.procurement.eligible_for_da,
          'Shortlisted Suppliers' => contract.procurement.procurement_suppliers.map { |s| s.supplier.data['supplier_name'] } .join(",\n"),
          'Unpriced services' => nil,
          'Route to market selected' => contract.procurement.route_to_market,
          'DA Suppliers (ranked)' => contract.procurement.procurement_suppliers.sort_by(&:direct_award_value) .map { |s| s.supplier.data['supplier_name'] },
          'DA Suppliers costs (ranked)' => contract.procurement.procurement_suppliers.sort_by(&:direct_award_value) .map(&:direct_award_value),
          'DA Awarded Supplier' => contract.supplier.data['supplier_name'],
          'DA Awarded Supplier cost' => contract.direct_award_value,
          'Contract number' => contract.contract_number,
          'DA Supplier decline reason' => contract.reason_for_declining,
          'DA Buyer withdraw reason' => contract.reason_for_closing,
          'DA Buyer not-sign reason' => contract.reason_for_not_signing,
          'DA Buyer contract signed date' => contract.contract_signed_date,
          'DA Buyer confirmed contract dates' => "#{contract.contract_start_date} - #{contract.contract_end_date}"
        }

        csv << row.keys if first
        csv << row.values
        first = false
      end
    end
  end

  def self.format_period_start_end(procurement)
    return '' if procurement.unanswered_contract_date_questions?

    "#{procurement.initial_call_off_period} years, " +
      [procurement.initial_call_off_start_date, procurement.initial_call_off_end_date].join(' - ')
  end

  def self.format_mobilisation_start_end(procurement)
    return '' if procurement.mobilisation_period.nil?

    "#{procurement.mobilisation_period} weeks, " +
      [procurement.mobilisation_period_start_date, procurement.mobilisation_period_end_date].join(' - ')
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