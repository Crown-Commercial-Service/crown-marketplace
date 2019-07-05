module ManagementConsultancy
  class Lot
    include StaticRecord

    attr_accessor :number, :description, :framework

    def self.[](number)
      Lot.find_by(number: number)
    end

    def full_description
      "#{description} (#{number})"
    end

    def self.all_numbers
      all.map(&:number)
    end

    def services
      ManagementConsultancy::Service.where(lot_number: number).sort_by(&:name)
    end
  end

  Lot.load_csv('management_consultancy/lots.csv')
end
