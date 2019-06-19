module LegalServices
  class Journey::RegionalLegalService
    include Steppable
    attribute :region_all, Array
    validate :validate_regional_legal_service
    def next_step_class
      Journey::Suppliers
    end
    private

    def validate_regional_legal_service
      byebug
      errors.add(:region_all, :too_short) if region_all.nil?
    end
  end
end
