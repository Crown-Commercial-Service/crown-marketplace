module LegalServices
  class Journey::SupplierDetails
    include Steppable
    def next_step_class
      Journey::SupplierDetails
    end
  end
end
