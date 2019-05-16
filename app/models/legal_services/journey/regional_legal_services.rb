module LegalServices
  class Journey::RegionalLegalServices
    include Steppable
    attribute :legal_services
    validates :legal_services, inclusion: ['yes', 'no', 'other']

    def next_step_class
      SupplierResults
    end
  end
end
