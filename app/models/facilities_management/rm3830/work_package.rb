module FacilitiesManagement
  module RM3830
    class WorkPackage
      include StaticRecord

      attr_accessor :code, :name
    end

    WorkPackage.load_csv('facilities_management/rm3830/work_packages.csv')
  end
end
