module LegalServices
  class Journey::RegionalLegalService
    include Steppable
    attribute :regional_legal_service
    validate :validate_regional_legal_service

    def next_step_class
      Journey::SupplierResults
    end

    private

    def validate_regional_legal_service
      errors.add(:regional_legal_service, :too_short) if regional_legal_service.nil?
    end
  end
end
