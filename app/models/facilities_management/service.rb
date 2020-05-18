module FacilitiesManagement
  class Service
    include Virtus.model
    include StaticRecord

    attribute :code, String
    attribute :name, String
    attribute :work_package_code, String
    attribute :mandatory, Axiom::Types::Boolean

    def work_package
      WorkPackage.find_by(code: work_package_code)
    end

    def mandatory?
      mandatory
    end

    def self.all_codes
      all.map(&:code)
    end

    def self.special_da_service?(code)
      ['M.1', 'N.1', 'O.1'].include? code
    end
  end

  Service.load_csv('facilities_management/services.csv')
end
