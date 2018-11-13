module ManagementConsultancy
  class Service
    include StaticRecord

    attr_accessor :code, :name, :lot_number
  end

  Service.load_csv('management_consultancy/services.csv')
end
