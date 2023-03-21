class AddFacilitiesManagementFrameworksData < ActiveRecord::Migration[6.1]
  class Frameworks < ApplicationRecord
    self.table_name = :frameworks
  end

  def up
    truncate_frameworks_table

    Frameworks.create(service: 'facilities_management', framework: 'RM3830', live_at: Time.new(2018, 7, 10).in_time_zone('London'), expires_at: Time.new(2023, 4, 9).in_time_zone('London'))
    Frameworks.create(service: 'facilities_management', framework: 'RM6232', live_at: Time.new(2022, 7, 14).in_time_zone('London'), expires_at: Time.new(2026, 6, 8).in_time_zone('London'))
  end

  def down
    truncate_frameworks_table
  end

  private

  def truncate_frameworks_table
    ActiveRecord::Base.connection.truncate_tables(:frameworks)
  end
end
