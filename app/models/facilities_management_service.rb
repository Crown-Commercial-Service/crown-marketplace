class FacilitiesManagementService
  include StaticRecord

  attr_accessor :code, :name, :work_package_code
end

FacilitiesManagementService.load_csv('facilities_management_services.csv')
