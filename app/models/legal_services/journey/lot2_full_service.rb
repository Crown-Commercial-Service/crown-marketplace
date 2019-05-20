module LegalServices
  class Journey::Lot2FullService
    include Steppable
    attribute :lot2_full_service, Array
    validates :lot2_full_service, length: { minimum: 1 }
    include Steppable
    def next_step_class
      Journey::LegalJurisdiction
    end
  end
end
