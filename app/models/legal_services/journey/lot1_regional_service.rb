module LegalServices
  class Journey::Lot1RegionalService
    include Steppable
    attribute :lot1_regional_service
    validate :validate_lot1_regional_service

    def next_step_class
      Journey::RegionalLegalService
    end

    private

    def validate_lot1_regional_service
      errors.add(:lot1_regional_service, :too_short) if lot1_regional_service.nil?
    end
  end
end
