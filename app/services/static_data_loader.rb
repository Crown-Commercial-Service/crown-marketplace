class StaticDataLoader
  @queries = {
    Region: 'SELECT code, name FROM fm_regions',
    Rates: 'SELECT code, framework, benchmark FROM fm_rates',
    Nuts1Region: 'SELECT code, name FROM nuts_regions where  nuts1_code is null and nuts2_code is null',
    Nuts2Region: 'SELECT code, nuts1_code, name FROM nuts_regions where not nuts1_code is null',
    Nuts3Region: 'SELECT code, name, nuts2_code FROM nuts_regions where not nuts2_code is null',
  }

  def self.load_static_data(static_data_class)
    class_name = static_data_class.name.demodulize
    begin
      # typical SQL select query
      # query = <<~SQL
      #   SELECT code, name FROM fm_regions
      # SQL
      query = @queries[class_name.to_sym]
      static_data_class.load_db(query)
    rescue StandardError
      call_rake static_data_class, class_name, query if static_data_class.all.count.zero?
    end
  end

  def self.call_rake(static_data_class, class_name, query)
    if File.split($PROGRAM_NAME).last == 'rake'
      Rails.logger.info('Guess what, I`m running this from Rake')
    else
      begin
        Rails.logger.info('No, this is not a Rake task')
        Rails.application.load_tasks
        Rake::Task['db:static'].execute
        # reload the data a second time
        static_data_class.load_db(query)
      rescue StandardError
        message = class_name + " data is missing! Please run 'rake db:static' to load static data."
        Rails.logger.info("\e[5;37;41m\n" + message + "\033[0m\n")
        raise error
      end
    end
  end
end
