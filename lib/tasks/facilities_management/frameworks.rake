module Frameworks
  def self.rm6232_live_at
    if Rails.env.test?
      1.day.ago
    else
      Time.new(2022, 7, 14).in_time_zone('London')
    end
  end

  def self.add_frameworks
    ActiveRecord::Base.connection.truncate_tables(:facilities_management_frameworks)

    FacilitiesManagement::Framework.create(framework: 'RM3830', live_at: Time.new(2020, 6, 26).in_time_zone('London'))
    FacilitiesManagement::Framework.create(framework: 'RM6232', live_at: rm6232_live_at)
  end
end

namespace :db do
  desc 'add the frameworks into the database'
  task fm_frameworks: :environment do
    p 'Loading FM Frameworks'
    DistributedLocks.distributed_lock(157) do
      Frameworks.add_frameworks
    end
  end

  desc 'add static data to the database'
  task static: :fm_frameworks
end
