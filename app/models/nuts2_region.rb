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
  if Nuts2Region.all.count == 0
    if File.split($0).last == 'rake' || $rails_rake_task
      puts 'Guess what, I`m running from Rake'
    else
      puts 'No; this is not a Rake task'
      message = "Nuts2Region data is missing. Please run 'rake db:setup' to load static data."
      puts "\e[5;37;41m\n" + message + "\033[0m\n"
      raise detail
    end
  end

end

