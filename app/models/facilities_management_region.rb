class FacilitiesManagementRegion
  include StaticRecord

  attr_accessor :code, :name

  def nuts2_code
    code[0, 4]
  end

  def nuts2_region
    Nuts2Region.find_by(code: nuts2_code)
  end

  def nuts3_code
    code.length > 4 ? code : nil
  end

  def nuts3_region
    nuts3_code ? Nuts3Region.find_by(code: nuts3_code) : nil
  end
end

FacilitiesManagementRegion.load_csv('facilities_management_regions.csv')
