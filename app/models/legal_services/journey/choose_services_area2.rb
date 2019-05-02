module LegalServices
  class Journey::ChooseServicesArea
    include Steppable

    attribute :central_government
    validates :central_government, inclusion: ['yes', 'no']

    def next_step_class
      case central_government
      when 'yes'
        Journey::FeesUnder20k
      else
        Journey::ChooseServicesArea2
      end
    end
  end
end
