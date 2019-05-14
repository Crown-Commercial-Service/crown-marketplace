module LegalServices
  class Journey::CheckSuitability
    include Steppable
    attribute :legal_services
    validates :legal_services, inclusion: ['yes', 'no', 'other']

    def next_step_class
      case legal_services
      when 'yes', 'no'
        Journey::SupplierResults
      when 'other'
        Journey::Sorry
      end
    end
  end
end
