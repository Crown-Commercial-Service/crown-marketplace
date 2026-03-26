namespace :db do
  desc 'add the frameworks into the database'
  task frameworks: :environment do
    puts 'Loading Frameworks'
    DataLoader::Frameworks.load_frameworks unless Rails.env.production?
  end

  task update_frameworks: :environment do
    puts 'Loading Framework updates'
    DataLoader::Frameworks.update_frameworks
  end

  desc 'Makes framework live for cucumber tests'
  task :make_framework_live, [:framework] => :environment do |_t, args|
    if Rails.env.test?
      puts "Making framework #{args[:framework]} live"
      DataLoader::Frameworks.make_framework_live(args[:framework])
    end
  end

  desc 'add static data to the database'
  task static: :frameworks
end
