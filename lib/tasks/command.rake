module Command
  def self.run_rake_tasks
    # ENV['RAKE_TASK_LIST'] is a comma seperated lists of the rake tasks that need to be run e.g. db:static,further_competition:update_fc_data

    return unless ENV['RAKE_TASK_LIST']

    DistributedLocks.distributed_lock(156) do
      ENV['RAKE_TASK_LIST'].split(',').each do |rake_task|
        puts "Running: #{rake_task}"
        Rake::Task[rake_task].invoke
      end
    end
  end
end

namespace :command do
  desc 'Runs rake tasks from a list'
  task run: :environment do
    puts 'Started running the rake tasks'
    Command.run_rake_tasks
    puts 'Finished running the rake tasks'
  end
end
