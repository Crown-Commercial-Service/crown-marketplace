module FacilitiesManagement
  module RM6378
    class WorkPackage < ApplicationRecord
      self.table_name = 'facilities_management_rm6378_work_packages'
      
      has_many :services, foreign_key: :work_package_code, primary_key: :code, inverse_of: :work_package
    end
  end
end