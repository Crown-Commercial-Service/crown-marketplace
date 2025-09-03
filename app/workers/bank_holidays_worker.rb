class BankHolidaysWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: false

  def perform
    BankHolidaysDataLoader.add_bank_holidays_from_csv_data_and_api
  end
end
