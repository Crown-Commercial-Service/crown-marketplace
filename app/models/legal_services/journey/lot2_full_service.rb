module LegalServices
  class Journey::Lot2FullService
    include Steppable
    attribute :lot_region, Array
    validates :lot_region, length: { minimum: 1 }
    include Steppable
    def next_step_class
      Journey::LegalJurisdiction
    end
  end
end
