module LegalServices
  class Journey::Lot1RegionalService
    include Steppable
    attribute :lot, Array
    validates :lot, length: { minimum: 1 }
    def next_step_class
      Journey::Lot2FullService
    end
  end
end
