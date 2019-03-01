class Nuts1Region
  include StaticRecord

  attr_accessor :code, :name

  def nuts2_regions
    Nuts2Region.where(nuts1_code: code)
  end
end

StaticDataLoader.load_static_data(Nuts1Region)
