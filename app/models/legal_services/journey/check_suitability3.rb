module LegalServices
  class Journey::CheckSuitability3
    include Steppable

    attribute :central_government
    validates :central_government, inclusion: ['yes', 'no']

    def next_step_class
	byebug
      case central_government
      when 'yes'
	byebug
        Journey::Lot1RegionalService
      else
        Journey::Lot1RegionalService
      end
    end
  end
end
