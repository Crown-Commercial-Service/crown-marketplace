class FacilitiesManagement::Lot
  include StaticRecord

  attr_accessor :number, :description

  def direct_award_possible?
    number == '1a'
  end
end

FacilitiesManagement::Lot.load_csv('facilities_management/lots.csv')
