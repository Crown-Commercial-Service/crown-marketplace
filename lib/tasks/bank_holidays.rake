namespace :db do
  desc 'add the bank holidays into the database'
  task bank_holidays: :environment do
    puts 'Loading Bank Holidays'
    DistributedLocks.distributed_lock(155) do
      BankHolidaysDataLoader.add_bank_holidays_from_csv
    end
  end

  task update_bank_holidays: :environment do
    puts 'Updating Bank Holidays CSV'
    DistributedLocks.distributed_lock(156) do
      BankHolidaysDataLoader.update_bank_holidays_csv
    end
  end

  desc 'add static data to the database'
  task static: :bank_holidays
end
