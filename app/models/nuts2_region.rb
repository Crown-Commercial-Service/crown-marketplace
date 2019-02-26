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


#Nuts2Region.load_csv('nuts2_regions.csv')
begin
  query = <<~SQL
    SELECT code, nuts1_code, name FROM nuts_regions where not nuts1_code is null
  SQL
  Nuts2Region.load_db(query)
rescue => detail
  print detail.backtrace.join("\n")
end

