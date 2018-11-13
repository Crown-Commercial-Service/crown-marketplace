module ManagementConsultancy
  class Lot
    include StaticRecord

    attr_accessor :number, :description
  end

  Lot.load_csv('management_consultancy/lots.csv')
end
