module LegalServices
  class Journey::Lot2FullService
    include Steppable
    attribute :lot2_full_service
    validate :validate_lot2_full_service

    def next_step_class
      Journey::LegalJurisdiction
    end

    private

    def validate_lot2_full_service
      errors.add(:lot2_full_service, :too_short) if lot2_full_service.nil?
    end
  end
end
