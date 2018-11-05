class FacilitiesManagementService
  include StaticRecord

  attr_accessor :code, :name, :work_package_code

  def work_package
    FacilitiesManagementWorkPackage.find_by(code: work_package_code)
  end
end

FacilitiesManagementService.load_csv('facilities_management_services.csv')
