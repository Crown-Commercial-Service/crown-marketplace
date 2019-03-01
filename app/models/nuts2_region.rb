class Nuts2Region
  include StaticRecord

  attr_accessor :code, :nuts1_code, :name

  def nuts1_region
    Nuts1Region.find_by(code: nuts1_code)
  end

  def nuts3_regions
    Nuts3Region.where(nuts2_code: code)
  end

  def self.all_codes
    all.map(&:code)
  end
end

# Nuts2Region.load_csv('nuts2_regions.csv')
StaticDataLoader.load_static_data(Nuts2Region)
