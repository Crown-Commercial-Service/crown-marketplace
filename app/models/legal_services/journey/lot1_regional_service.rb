module LegalServices
  class Journey::Lot1RegionalService
    include Steppable

    attribute :central_government

    def next_step_class
      case central_government
      when 'yes'
        byebug
        Journey::Lot1RegionalService
      else
        Journey::ChooseServicesArea2
      end
    end
  end
end
