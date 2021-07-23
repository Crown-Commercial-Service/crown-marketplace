module FacilitiesManagement
  class BuildingType < ApplicationRecord

    def building_type_standard
      standard_building_type ? 'STANDARD' : 'NON-STANDARD'
    end
  end
end
