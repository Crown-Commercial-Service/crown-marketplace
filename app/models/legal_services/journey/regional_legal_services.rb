<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
module LegalServices
  class Journey::Lot1RegionalService
    include Steppable

    attribute :central_government
    validates :central_government, inclusion: ['yes', 'no']

    def next_step_class
      case central_government
      when 'yes'
        Journey::Lot1RegionalService
      else
        Journey::ChooseServicesArea2
      end
    end
  end
end
