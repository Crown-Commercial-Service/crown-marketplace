module FacilitiesManagement
  module ProcurementsHelper
    def section_has_error?(section)
      return false unless @procurement.errors.any?

      requirements_errors_list.keys.intersect?(section_errors(section))
    end

    def section_id(section)
      "#{section.downcase.gsub(' ', '-')}-tag"
    end

    def requirements_errors_list
      @requirements_errors_list ||= @procurement.errors.details[:base].map.with_index { |detail, index| [detail[:error], @procurement.errors[:base][index]] }.to_h
    end

    def section_errors(section)
      if section == 'contract_period'
        %i[contract_period_incomplete initial_call_off_period_in_past mobilisation_period_in_past mobilisation_period_required]
      else
        ["#{section}_incomplete".to_sym]
      end
    end

    def display_all_errors(errors, section_errors)
      capture do
        section_errors.each do |attribute|
          next unless errors[attribute]

          concat(tag.span(errors[attribute].to_s, id: error_id(attribute), class: 'govuk-error-message'))
        end
      end
    end

    def active_procurement_buildings
      @active_procurement_buildings ||= @procurement.active_procurement_buildings.order_by_building_name
    end
  end
end
