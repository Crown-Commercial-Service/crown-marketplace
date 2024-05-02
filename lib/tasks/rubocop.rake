if Rails.env.local?
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new
end
