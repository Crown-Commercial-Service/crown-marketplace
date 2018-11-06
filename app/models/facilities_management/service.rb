class FacilitiesManagement::Service
  include StaticRecord

  attr_accessor :code, :name, :work_package_code, :mandatory

  def work_package
    FacilitiesManagement::WorkPackage.find_by(code: work_package_code)
  end

  def mandatory?
    mandatory == 'true'
  end
end

FacilitiesManagement::Service.load_csv('facilities_management_services.csv')
