module FacilitiesManagement
  class Service
    include StaticRecord

    attr_accessor :code, :name, :work_package_code, :mandatory

    def work_package
      WorkPackage.find_by(code: work_package_code)
    end

    def mandatory?
      mandatory == 'true'
    end

    def self.all_codes
      all.map(&:code)
    end
  end

  Service.load_csv('facilities_management/services.csv')
end
