module FacilitiesManagement
  class WorkPackage
    include StaticRecord

    attr_accessor :code, :name
  end

  WorkPackage.load_csv('facilities_management/work_packages.csv')
end
