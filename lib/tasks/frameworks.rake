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

  task make_rm6232_live: :environment do
    DistributedLocks.distributed_lock(151) do
      if Rails.env.test?
        puts 'Making RM6232 live'
        Framework.find('RM6232').update(expires_at: 1.day.from_now)
      end
    end
  end

  desc 'add static data to the database'
  task static: :frameworks
end
