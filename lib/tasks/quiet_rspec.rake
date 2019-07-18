if defined? RSpec
  require 'rspec/core/rake_task'

  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false

    # Rake::Task['db:static'].invoke
    system('rake db:static RAILS_ENV=test')
  end
end
