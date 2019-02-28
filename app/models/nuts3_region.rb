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
  if Nuts3Region.all.count == 0
    if File.split($0).last == 'rake' || $rails_rake_task
      puts 'Guess what, I`m running from Rake'
    else
      puts 'No; this is not a Rake task'
      message = "Nuts3Region data is missing. Please run 'rake db:setup' to load static data."
      puts "\e[5;37;41m\n" + message + "\033[0m\n"
      raise detail
    end
  end
end
