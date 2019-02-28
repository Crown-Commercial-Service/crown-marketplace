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
  if Nuts1Region.all.count == 0
    if File.split($0).last == 'rake' || $rails_rake_task
      puts 'Guess what, I`m running from Rake'
    else
      puts 'No; this is not a Rake task'
      message = "Nuts1Region data is missing. Please run 'rake db:setup' to load static data."      
      puts "\e[5;37;41m\n" + message + "\033[0m\n"
      raise detail
    end
  end

end
