module LegalServices
  class Journey::LegalJurisdiction
    include Steppable

    attribute :legal_jurisdiction
    validates :legal_jurisdiction, inclusion: ['yes', 'no']

    def next_step_class
      suppliers
    end
  end
end
