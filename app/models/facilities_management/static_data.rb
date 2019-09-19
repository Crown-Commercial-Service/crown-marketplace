module FacilitiesManagement
  class StaticData < ApplicationRecord
    self.table_name = 'fm_static_data'

    def self.work_packages
      find_by(key: 'work_packages').value
    end

    def self.services
      find_by(key: 'services').value
    end
  end
end
