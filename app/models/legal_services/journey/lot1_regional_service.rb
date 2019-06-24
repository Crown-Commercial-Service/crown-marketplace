module LegalServices
  class Journey::Lot1RegionalService
    include Steppable
    attribute :lot1_regional_service, Array
    validates :lot1_regional_service, length: { minimum: 1 }

    def next_step_class
      Journey::RegionalLegalService
    end
  end
end
