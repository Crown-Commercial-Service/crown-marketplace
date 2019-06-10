module LegalServices
  class Journey::RegionalLegalService
    include Steppable
    attribute :region1, Array
    validates :region1, length: { minimum: 1 }

    def next_step_class
      Journey::SupplierResults
    end
  end
end
