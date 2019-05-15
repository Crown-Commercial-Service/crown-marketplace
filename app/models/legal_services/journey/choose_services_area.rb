module LegalServices
  class Journey::ChooseServicesArea
    include Steppable

    attribute :services_area
    validates :services_area, inclusion: ['yes', 'no', 'other']

    def next_step_class
      case services_area
      when 'yes'
        Journey::SupplierResults
      else
        Journey::ChooseServicesArea2
      end
    end
  end
end
