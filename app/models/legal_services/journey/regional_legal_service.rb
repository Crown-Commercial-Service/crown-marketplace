module LegalServices
  class Journey::RegionalLegalService
    include Steppable
    attribute :lot, Array
    validates :lot, length: { minimum: 1 }

    def next_step_class
      Journey::SupplierResults
    end
  end
end
