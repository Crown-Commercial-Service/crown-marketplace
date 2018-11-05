class FacilitiesManagementLot
  include StaticRecord

  attr_accessor :number, :description
end

FacilitiesManagementLot.load_csv('facilities_management_lots.csv')
