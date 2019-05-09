module LegalServices
  class Journey::CheckSuitability
    include Steppable
    attribute :legal_services
    validates :legal_services, inclusion: ['yes', 'no', 'other']

    def next_step_class
      case legal_services
      when 'yes'
      when 'no'
        Journey::CheckSuitability2
      when 'other'
        Journey::Sorry
      end
    end
  end
end
