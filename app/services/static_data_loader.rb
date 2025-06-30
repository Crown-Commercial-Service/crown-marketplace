class StaticDataLoader
  @queries = {
    Region: 'SELECT code, name FROM facilities_management_regions;',
    Nuts1Region: 'SELECT code, name FROM nuts_regions where  nuts1_code is null and nuts2_code is null',
    Nuts2Region: 'SELECT code, nuts1_code, name FROM nuts_regions where not nuts1_code is null',
    Nuts3Region: 'SELECT code, name, nuts2_code FROM nuts_regions where not nuts2_code is null',
  }

  def self.load_static_data(static_data_class)
    class_name = static_data_class.name.demodulize
    begin
      # typical SQL select query
      # query = <<~SQL
      #   SELECT code, name FROM facilities_management_regions
      # SQL
      query = @queries[class_name.to_sym]
      static_data_class.load_db(query)
    rescue StandardError
      call_rake static_data_class, class_name, query if static_data_class.none?
    end
  end

  def self.call_rake(static_data_class, class_name, query)
    if File.split($PROGRAM_NAME).last == 'rake'
      Rails.logger.info('')
    else
      begin
        Rails.logger.info('No, this is not a Rake task')
        Rails.application.load_tasks
        Rake::Task['db:static'].execute
        # reload the data a second time
        static_data_class.load_db(query)
      rescue StandardError => e
        message = "#{class_name} data is missing! Please run 'rake db:static' to load static data."
        Rails.logger.info("\e[5;37;41m\n#{message}\e[0m\n")
        Rails.logger.info("\e[5;37;41m\n#{e}\e[0m\n")
        raise e
      end
    end
  end
end
