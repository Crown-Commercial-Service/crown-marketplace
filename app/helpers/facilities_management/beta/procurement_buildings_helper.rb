module FacilitiesManagement::Beta::ProcurementBuildingsHelper
  def service_questions(code)
    FacilitiesManagement::ProcurementBuildingService::SERVICES_AND_QUESTIONS.select { |service| service[:code] == code }.first
  end
end
