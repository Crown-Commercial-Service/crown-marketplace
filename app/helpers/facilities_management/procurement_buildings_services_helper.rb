module FacilitiesManagement::ProcurementBuildingsServicesHelper
  def volume_question(pbs)
    [] unless pbs.this_service[:context].key? :volume
    pbs.this_service[:context][:volume]&.first
  end

  def service_standard_type
    @building_service.this_service[:context].select { |_, attributes| attributes.first == :service_standard }.keys.first
  end

  def specific_lift_error?(model, error_type, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index && item[:error] == error_type }.present?
  end

  def any_lift_error?(model, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index }.present?
  end
end
