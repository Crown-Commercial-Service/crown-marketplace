module FacilitiesManagement
  module RM3830
    class WorkPackage
      include StaticRecord

      attr_accessor :code, :name
    end
  end

  WorkPackage.load_csv('facilities_management/work_packages.csv')
end
