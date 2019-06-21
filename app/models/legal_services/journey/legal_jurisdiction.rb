module LegalServices
  class Journey::LegalJurisdiction
    include Steppable

    attribute :legal_jurisdiction
    validates :legal_jurisdiction, inclusion: ['E', 'S', 'N']

    def next_step_class
      Journey::Suppliers
    end
  end
end
