class Nuts1Region
  include StaticRecord

  attr_accessor :code, :name

  def nuts2_regions
    Nuts2Region.where(nuts1_code: code)
  end
end

# Nuts1Region.load_csv('nuts1_regions.csv')
begin
  query = <<~SQL
    SELECT code, name FROM nuts_regions where  nuts1_code is null and nuts2_code is null
  SQL
  Nuts1Region.load_db(query)
rescue => detail
  print detail.backtrace.join("\n")
end
