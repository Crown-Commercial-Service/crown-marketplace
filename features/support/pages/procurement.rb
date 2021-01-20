module Pages
  class Procurement < SitePrism::Page
    element :contract_name_field, '#facilities_management_procurement_contract_name'
    element :contract_name, '#main-content > div.govuk-body > div > span'

    section 'Contract details', 'form > table:nth-of-type(1)' do
      section 'Contract name', 'tr:nth-of-type(1)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Estimated annual cost', 'tr:nth-of-type(2)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'TUPE', 'tr:nth-of-type(3)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Contract period', 'tr:nth-of-type(4)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end
    end

    section 'Services and buildings', 'form > table:nth-of-type(2)' do
      section 'Services', 'tr:nth-of-type(1)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Buildings', 'tr:nth-of-type(2)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Assigning services to buildings', 'tr:nth-of-type(3)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end

      section 'Service requirements', 'tr:nth-of-type(4)' do
        element :name, 'td:nth-of-type(1)'
        element :status, 'td:nth-of-type(2)'
      end
    end

    element :estimated_cost_known_yes, '#facilities_management_procurement_estimated_cost_known_true'
    element :estimated_cost_known_no, '#facilities_management_procurement_estimated_cost_known_true'
    element :estimated_cost_known, '#facilities_management_procurement_estimated_annual_cost'

    element :tupe_yes, '#facilities_management_procurement_tupe_true'
    element :tupe_no, '#facilities_management_procurement_tupe_false'

    element :initial_call_off_period_years, '#facilities_management_procurement_initial_call_off_period_years'
    element :initial_call_off_period_months, '#facilities_management_procurement_initial_call_off_period_months'
    element :initial_call_off_period_day, '#facilities_management_procurement_initial_call_off_start_date_dd'
    element :initial_call_off_period_month, '#facilities_management_procurement_initial_call_off_start_date_mm'
    element :initial_call_off_period_year, '#facilities_management_procurement_initial_call_off_start_date_yyyy'

    element :mobilisation_period_yes, '#facilities_management_procurement_mobilisation_period_required_true'
    element :mobilisation_period_no, '#facilities_management_procurement_mobilisation_period_required_false'

    element :extension_required_yes, '#facilities_management_procurement_extensions_required_true'
    element :extension_required_no, '#facilities_management_procurement_extensions_required_false'

    element :service_volume_questions, 'table:nth-of-type(1)'
    element :service_standard_questions, 'table:nth-of-type(2)'

    element :building_status, '.govuk-body > span > strong'

    element :direct_award_route_to_market, '#facilities_management_procurement_route_to_market_da_draft'
    element :further_competition_route_to_market, '#facilities_management_procurement_route_to_market_further_competition_chosen'
  end
end
