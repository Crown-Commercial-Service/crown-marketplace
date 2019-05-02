module LegalServices
<<<<<<< Updated upstream
  class Journey::CheckSuitability
=======
  class Journey::CheckSuitability3
>>>>>>> Stashed changes
    include Steppable

    attribute :central_government
    validates :central_government, inclusion: ['yes', 'no']

    def next_step_class
      case central_government
      when 'yes'
<<<<<<< Updated upstream
        Journey::FeesUnder20k
      else
        Journey::ChooseServicesArea
=======
        Journey::Lot1RegionalService
      else
        Journey::Lot1RegionalService
>>>>>>> Stashed changes
      end
    end
  end
end
