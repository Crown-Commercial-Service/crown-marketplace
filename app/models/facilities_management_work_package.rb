class FacilitiesManagementWorkPackage
  include StaticRecord

  attr_accessor :code, :name
end

FacilitiesManagementWorkPackage.load_csv('facilities_management_work_packages.csv')
