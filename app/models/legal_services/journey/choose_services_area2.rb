module LegalServices
  class Journey::ChooseServicesArea2
    include Steppable

    attribute :central_government
    validates :central_government, inclusion: ['yes', 'no']

    def next_step_class
      case central_government
      when 'yes'
        Journey::Lot1RegionalService
      when 'no'
	Journey::Lot2FullService
      else
        Journey::Requirement
      end
    end
  end
end
