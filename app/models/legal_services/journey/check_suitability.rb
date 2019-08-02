module LegalServices
  class Journey::CheckSuitability
    include Steppable
    attribute :under_threshold
    attribute :lot
    validates :under_threshold, inclusion: ['yes', 'no']

    def next_step_class
      case under_threshold
      when 'yes'
        Journey::ChooseServices
      when 'no'
        Journey::Sorry
      end
    end
  end
end
