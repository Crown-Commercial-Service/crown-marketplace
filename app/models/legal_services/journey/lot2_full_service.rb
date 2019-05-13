module LegalServices
  class Journey::Lot2FullService
    include Steppable
    attribute :lot, Array
    validates :lot, length: { minimum: 1 }
    include Steppable
  end
end
