class Nuts3Region
  include StaticRecord

  attr_accessor :code, :nuts2_code, :name

  def nuts2_region
    Nuts2Region.find_by(code: nuts2_code)
  end

  delegate :nuts1_code, :nuts1_region, to: :nuts2_region
end

# Nuts3Region.load_csv('nuts3_regions.csv')
begin
  query = <<~SQL
    SELECT code, name, nuts2_code FROM nuts_regions where not nuts2_code is null
  SQL
  Nuts3Region.load_db(query)
rescue => detail
  print detail.backtrace.join("\n")
end
