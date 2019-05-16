module LegalServices
  class Journey::ChooseServicesArea2
    include Steppable

    attribute :services_area2
    validates :services_area2, inclusion: ['yes', 'no', 'other']

    def next_step_class
      case services_area2
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
