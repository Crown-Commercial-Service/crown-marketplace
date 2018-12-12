module SupplyTeachers
  class Lot
    include StaticRecord

    attr_accessor :number, :description

    def self.all_numbers
      all.map(&:number).map(&:to_i)
    end
  end

  Lot.load_csv('supply_teachers/lots.csv')
end
