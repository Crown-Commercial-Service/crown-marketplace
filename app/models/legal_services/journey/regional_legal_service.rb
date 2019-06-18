module LegalServices
  class Journey::RegionalLegalService
    include Steppable
    attribute :region_all, Array
    validates :region_all, length: { minimum: 1 }
    def next_step_class
      Journey::Suppliers
    end
  end
end
