class DataLoaderWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: false

  def perform(task_name)
    Rails.logger.info { "Running the task: #{task_name}" }

    DataLoader.new(task_name:).invoke_task
  end
end
