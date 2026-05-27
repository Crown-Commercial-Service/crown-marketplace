namespace :db do
  desc 'Imports test data into the test environment for cucumber tests'
  task import_test_data: :environment do
    if Rails.env.test?
      puts 'Importing the supplier test data'
      DataLoader::TestData.import_test_data
      puts 'Finished supplier test data import'
    end
  end

  desc 'Imports test data for a specific framework into the test environment for cucumber tests'
  task :import_test_data_for_framework_service, [:framework] => :environment do |_t, args|
    if Rails.env.test?
      puts "Importing the supplier test data for #{args[:framework]}"
      DataLoader::TestData.import_test_data_for_framework_service(args[:framework])
      puts "Finished supplier test data import for #{args[:framework]}"
    end
  end

  desc 'Imports test data into the development environment'
  task import_test_data_to_development: :environment do
    if Rails.env.development?
      puts 'Importing the supplier test data to development'
      DataLoader::TestData.import_test_data
      puts 'Finished supplier test data import'
    end
  end

  task import_test_data: :static
  task import_test_data_for_framework_service: :static
end
