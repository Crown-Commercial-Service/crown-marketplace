module Pages
  class ServiceRequirement < SitePrism::Page
    element :service_volume_questions, 'table:nth-of-type(1)'
    element :service_standard_questions, 'table:nth-of-type(2)'

    element :add_lifts, '.add-lifts'
    elements :lift_rows, '.lift-row'

    element :volume_label, 'label'
    element :volume_unit, '.ccs-unit-label'
  end
end
