module LegalServices
  class Journey::ChooseServicesArea2
    include Steppable

    attribute :services_area
    validates :services_area, inclusion: ['yes', 'no']

    def next_step_class
      case services_area
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
