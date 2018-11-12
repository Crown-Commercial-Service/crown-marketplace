if Rails.env.development? || Rails.env.test?
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:rubocop)

  task(:default).clear.enhance(%i[rubocop spec])
end
