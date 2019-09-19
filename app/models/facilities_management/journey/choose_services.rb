module FacilitiesManagement
  class Journey::ChooseServices
    include Steppable

    attribute :service_codes, Array
    validates :service_codes, length: { minimum: 1 }

    def services
      FacilitiesManagement::StaticData.services
    end

    def work_packages
      FacilitiesManagement::StaticData.work_packages
    end

    def next_step_class
      Journey::ChooseLocations
    end
  end
end
