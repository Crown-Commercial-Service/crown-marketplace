module Pages::RM3830
  class ServiceRequirement < SitePrism::Page
    element :service_volume_questions, 'table:nth-of-type(1)'
    element :service_standard_questions, 'table:nth-of-type(2)'

    element :add_lifts, '.add-lifts'
    elements :lift_rows, '.lift-row'
    elements :number_of_floors_inputs, '.number-of-floors'

    element :volume_input, 'input[type="text"]'
    element :volume_label, 'label'
    element :volume_unit, '.govuk-input__suffix'

    element :hours_per_year, '#facilities_management_rm3830_procurement_building_service_service_hours'
    element :detail_of_requirement, '#facilities_management_rm3830_procurement_building_service_detail_of_requirement'

    element :service_standard_a, '#facilities_management_rm3830_procurement_building_service_service_standard_a'
    element :service_standard_b, '#facilities_management_rm3830_procurement_building_service_service_standard_b'
    element :service_standard_c, '#facilities_management_rm3830_procurement_building_service_service_standard_c'
  end
end
