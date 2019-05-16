module LegalServices
  class Journey::RegionalLegalService
    include Steppable
    attribute :lot1_region, Array
    validates :lot1_region, length: { minimum: 1 }

    def next_step_class
      Journey::SupplierResults
    end
  end
end
