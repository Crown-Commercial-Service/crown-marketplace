module LegalServices
  class Journey::Lot1RegionalService
    include Steppable
    attribute :lot_region, Array
    validates :lot_region, length: { minimum: 1 }
    def next_step_class
      Journey::Lot2FullService
    end
  end
end
