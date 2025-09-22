class ReportWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: false

  def perform(id)
    ReportCsvGenerator.new(id).generate
  end
end
