module LegalServices
  byebug
  class Journey::Lot2FullService
    byebug
    include Steppable
    attribute :lot, Array
    validates :lot, length: { minimum: 1 }
    include Steppable
  end
end
