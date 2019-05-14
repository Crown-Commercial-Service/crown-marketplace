module LegalServices
  class Journey::ChooseServicesArea
    include Steppable

    attribute :services_area
    validates :services_area, inclusion: ['yes', 'no']

    def next_step_class
      binding.pry
      case services_area
      when 'yes'
        Journey::FeesUnder20k
      else
        Journey::ChooseServicesArea2
      end
    end
  end
end
