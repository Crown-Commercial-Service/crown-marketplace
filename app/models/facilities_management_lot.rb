class FacilitiesManagementLot
  include StaticRecord

  attr_accessor :number, :description

  def direct_award_possible?
    number == '1a'
  end
end

FacilitiesManagementLot.load_csv('facilities_management_lots.csv')
