module ManagementConsultancy
  class Service
    include StaticRecord

    attr_accessor :code, :name, :lot_number, :framework

    def self.all_codes
      all.map(&:code)
    end

    def subservices
      ManagementConsultancy::Subservice.where(service: code)
    end
  end

  Service.load_csv('management_consultancy/services.csv')
end
