class LegacyDataLoaderWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'legacy_default', retry: false

  def perform(task_name)
    Rails.logger.info { "Running the task: #{task_name} from the wrong place" }

    DataLoader.new(task_name:).invoke_task
  end
end
