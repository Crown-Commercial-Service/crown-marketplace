module FacilitiesManagement
  module ProcurementConcern
    extend ActiveSupport::Concern
    include FacilitiesManagement::ProcurementValidator

    def contract_name_status
      contract_name.present? ? :completed : :not_started
    end

    def tupe_status
      tupe.nil? ? :not_started : :completed
    end

    def contract_period_status
      relevant_attributes = [
        initial_call_off_period_years,
        initial_call_off_period_months,
        initial_call_off_start_date,
        mobilisation_period_required,
        extensions_required
      ]

      return :not_started if relevant_attributes.all?(&:nil?)

      relevant_attributes.any?(&:nil?) ? :incomplete : :completed
    end

    def services_status
      @services_status ||= service_codes.any? ? :completed : :not_started
    end

    def buildings_status
      @buildings_status ||= active_procurement_buildings.any? ? :completed : :not_started
    end

    def buildings_and_services_status
      @buildings_and_services_status ||= if services_status == :not_started || buildings_status == :not_started
                                           :cannot_start
                                         else
                                           buildings_and_services_completed? ? :completed : :incomplete
                                         end
    end

    def buildings_and_services_completed?
      active_procurement_buildings.all?(&:service_selection_complete?)
    end

    def initial_call_off_period
      initial_call_off_period_years.years + initial_call_off_period_months.months
    end

    def initial_call_off_end_date
      period_end_date(initial_call_off_start_date, initial_call_off_period)
    end

    def mobilisation_start_date
      mobilisation_end_date - mobilisation_period.weeks
    end

    def mobilisation_end_date
      initial_call_off_start_date - 1.day
    end

    def extension_period_start_date(extension)
      initial_call_off_end_date + call_off_extensions.where(extension: (0..(extension - 1))).sum(&:period) + 1.day
    end

    def extension_period_end_date(extension)
      initial_call_off_end_date + call_off_extensions.where(extension: (0..extension)).sum(&:period)
    end

    def call_off_extension(extension)
      call_off_extensions.find_by(extension:)
    end

    def build_call_off_extensions
      4.times do |extension|
        call_off_extensions.find_or_initialize_by(extension:)
      end
    end

    private

    def period_end_date(start_date, period)
      end_date = start_date + period
      end_date -= 1.day if start_date.day == end_date.day
      end_date
    end
  end
end
