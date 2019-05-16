module LegalServices
  class Journey::RegionalLegalServices
    include Steppable
    attribute :region, Array
    validates :region, length: { minimum: 1 }

    def next_step_class
      Journey::SupplierResults
    end
  end
end
