if Rails.env.development? || Rails.env.test?
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new

  task(:default).clear.enhance(%i[rubocop spec])
end
