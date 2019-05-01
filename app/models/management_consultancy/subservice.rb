module ManagementConsultancy
  class Subservice
    include StaticRecord

    attr_accessor :code, :name, :service

    def self.all_codes
      all.map(&:code)
    end
  end

  Subservice.load_csv('management_consultancy/subservices.csv')
end
