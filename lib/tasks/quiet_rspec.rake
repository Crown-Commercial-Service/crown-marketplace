if defined? RSpec
  require 'rspec/core/rake_task'

  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    p '+++++++++++++++++++++++'
    Rake::Task['db:static'].invoke
    t.verbose = false
  end
end
