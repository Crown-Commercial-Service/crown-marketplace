module LegalServices
  class Lot
    include StaticRecord

    attr_accessor :number, :description

    def self.[](number)
      Lot.find_by(number: number)
    end

    def self.all_numbers
      all.map(&:number)
    end
  end

  Lot.load_csv('legal_services/lots.csv')
end
