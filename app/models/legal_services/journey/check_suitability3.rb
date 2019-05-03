module LegalServices
  class Journey::CheckSuitability3
    include Steppable
    attribute :lot, Array
    validates :lot, length: { minimum: 1 }
    def next_step_class
      Journey::Lot1RegionalService
    end
  end
end
