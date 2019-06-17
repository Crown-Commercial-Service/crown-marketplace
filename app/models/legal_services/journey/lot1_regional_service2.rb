module LegalServices
  class Journey::Lot1RegionalService2
    include Steppable
    attribute :lot1_regional_service, :string
    validate :validate_lot1_regional_service2

    def next_step_class
      Journey::RegionalLegalService
    end

    private

    def validate_lot1_regional_service2
      errors.add(:lot1_regional_service, :too_short) if lot1_regional_service.nil?
    end
  end
end
