module LegalServices
  class Journey::Lot1RegionalServices
    include Steppable
    attribute :lot, Array
    validates :lot, length: { minimum: 1 }
    def next_step_class
      Journey::RegionalLegalServices
    end
  end
end
