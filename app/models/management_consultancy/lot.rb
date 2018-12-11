module ManagementConsultancy
  class Lot
    include StaticRecord

    attr_accessor :number, :description

    def self.[](number)
      Lot.find_by(number: number)
    end

    def full_description
      "Lot #{number} - #{description}"
    end

    def self.all_numbers
      all.map(&:number)
    end
  end

  Lot.load_csv('management_consultancy/lots.csv')
end
