module FacilitiesManagement::RM3830::Admin::SublotServicesHelper
  def list_service_types_price
    @list_service_types_price ||= ['Direct Award Discount (%)', 'General office - Customer Facing (£)', 'General office - Non Customer Facing (£)', 'Call Centre Operations (£)', 'Warehouses (£)', 'Restaurant and Catering Facilities (£)', 'Pre-School (£)', 'Primary School (£)', 'Secondary Schools (£)', 'Special Schools (£)', 'Universities and Colleges (£)', 'Community - Doctors, Dentist, Health Clinic (£)', 'Nursing and Care Homes (£)']
  end

  def list_service_types_variance
    @list_service_types_variance ||= ['Direct Award Discount (%)', 'General office - Customer Facing (%)', 'General office - Non Customer Facing (%)', 'Call Centre Operations (%)', 'Warehouses (%)', 'Restaurant and Catering Facilities (%)', 'Pre-School (%)', 'Primary School (%)', 'Secondary Schools (%)', 'Special Schools (%)', 'Universities and Colleges (%)', 'Community - Doctors, Dentist, Health Clinic (%)', 'Nursing and Care Homes (%)']
  end

  def list_service_types(service_code)
    if ['M', 'N'].include?(service_code)
      list_service_types_variance
    else
      list_service_types_price
    end
  end

  def variance_names
    @variance_names ||= ['td_overhead_html', 'td_corporate', 'td_profit', 'td_london', 'td_cleaning_html', 'td_tupe', 'td_mobilisation']
  end

  def variance_values
    @variance_values ||= ['Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)']
  end

  def variances
    @variances ||= ['M.140', 'M.141', 'M.142', 'M.144', 'M.146', 'M.148', 'B.1']
  end

  def determine_rate_card_service_price_text(service_type, work_pckg_code, supplier_data_ratecard_prices, supplier_data_ratecard_discounts)
    if service_type == 'Direct Award Discount (%)'
      supplier_data_ratecard_discounts[work_pckg_code].nil? ? '' : supplier_data_ratecard_discounts[work_pckg_code]['Disc %']
    else
      supplier_data_ratecard_prices[work_pckg_code].nil? ? '' : supplier_data_ratecard_prices[work_pckg_code][service_type.remove(' (%)').remove(' (£)')]
    end
  end

  def service_has_error?(code)
    @invalid_services.keys.include?(code)
  end

  def service_type_has_error?(code, service_type)
    service_has_error?(code) ? @invalid_services[code].keys.include?(service_type) : false
  end

  def sublot_1a_error_message(error_type)
    tag.span class: 'govuk-error-message' do
      concat(tag.span('Error:', class: 'govuk-visually-hidden'))
      concat(t("facilities_management.rm3830.admin.sublot_services.services_prices_and_variances.error_message.#{error_type}"))
    end
  end

  def first_error_type
    return @invalid_services.first[1].first[1][:error_type] unless variances.include? @invalid_services.first[0]

    @invalid_services.first[1][:error_type]
  end
end
