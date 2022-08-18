class Nuts1Region
  include StaticRecord

  attr_accessor :code, :name

  def nuts2_regions
    Nuts2Region.where(nuts1_code: code)
  end

  def self.all_codes
    all.map(&:code)
  end

  def self.all_with_overseas
    all + [new(code: 'OS0', name: 'Overseas')]
  end
end

StaticDataLoader.load_static_data(Nuts1Region)
