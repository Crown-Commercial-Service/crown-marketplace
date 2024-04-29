module Frameworks
  def self.rm6232_expires_at
    if Rails.env.test?
      1.year.from_now
    else
      # This is not correct but it is far in the future and we can update it with another migration later on
      Time.new(2026, 6, 8).in_time_zone('London')
    end
  end

  def self.add_frameworks
    ActiveRecord::Base.connection.truncate_tables(:frameworks)

    Framework.create(service: 'facilities_management', framework: 'RM3830', live_at: Time.new(2018, 7, 10).in_time_zone('London'), expires_at: Time.new(2023, 4, 6).in_time_zone('London'))
    Framework.create(service: 'facilities_management', framework: 'RM6232', live_at: Time.new(2022, 7, 14).in_time_zone('London'), expires_at: rm6232_expires_at)
  end
end

namespace :db do
  desc 'add the frameworks into the database'
  task fm_frameworks: :environment do
    puts 'Loading FM Frameworks'
    DistributedLocks.distributed_lock(157) do
      Frameworks.add_frameworks
    end
  end

  desc 'add static data to the database'
  task static: :fm_frameworks
end
