module LegalServices
  class Journey::CheckSuitability2
    include Steppable

    attribute :fees
    validates :fees, inclusion: ['yes', 'no']

    def next_step_class
      case fees
      when 'yes'
        byebug
        Journey::Lot1RegionalService2
      else
        Journey::Sorry
      end
    end
  end
end
