module SupplyTeachers
  class Journey::FixedTermResults
    include ::Journey::Step
    include Journey::Results
    include ActiveSupport::NumberHelper

    def rates
      Rate.direct_provision.fixed_term
    end

    def rate(branch)
      branch.supplier.fixed_term_rate
    end

    def inputs
      {
        looking_for: translate_input('supply_teachers.looking_for.worker'),
        worker_type: translate_input('supply_teachers.worker_type.agency_supplied'),
        payroll_provider: translate_input('supply_teachers.payroll_provider.school'),
        postcode: postcode,
        radius: number_to_human(radius, units: :miles)
      }
    end
  end
end
