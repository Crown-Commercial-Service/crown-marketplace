require 'csv'

module Frameworks
  FRAMEWORKS_FILE_PATH = Rails.root.join('data', 'frameworks.csv')
  LOTS_FILE_PATH = Rails.root.join('data', 'lots.csv')
  SERVICES_FILE_PATH = Rails.root.join('data', 'services.csv')
  JURISDICTIONS_FILE_PATH = Rails.root.join('data', 'jurisdictions.csv')
  POSITIONS_FILE_PATH = Rails.root.join('data', 'positions.csv')

  def self.models_with_file_paths
    [
      [Framework, FRAMEWORKS_FILE_PATH],
      [Lot, LOTS_FILE_PATH],
      [Service, SERVICES_FILE_PATH],
      [Jurisdiction, JURISDICTIONS_FILE_PATH],
      [Position, POSITIONS_FILE_PATH]
    ]
  end

  # rubocop:disable Metrics/AbcSize
  def self.framework_with_transformed_dates(framework)
    framework['live_at'] = Time.new(*framework['live_at'].split('-')).in_time_zone('London')
    framework['expires_at'] = Time.new(*framework['expires_at'].split('-')).in_time_zone('London')

    if Rails.env.test?
      case framework['id']
      when 'RM6238', 'RM6240', 'RM6232'
        framework['expires_at'] = 1.year.from_now
      when 'RM6187'
        framework['expires_at'] = 1.year.ago
      when 'RM6309', 'RM6360'
        framework['live_at'] = 1.year.ago
        framework['expires_at'] = 1.year.from_now
      end
    end

    framework
  end
  # rubocop:enable Metrics/AbcSize

  def self.truncate_frameworks
    ActiveRecord::Base.connection.truncate_tables(
      :frameworks,
      :lots,
      :services,
      :jurisdictions,
      :positions,
      :uploads,
      :searches,
      :reports,
      :supplier_frameworks,
      :supplier_framework_lots,
      :supplier_framework_contact_details,
      :supplier_framework_addresses,
      :supplier_framework_lot_services,
      :supplier_framework_lot_jurisdictions,
      :supplier_framework_lot_rates,
      :supplier_framework_lot_branches,
    )
  end

  def self.add_or_update_frameworks
    models_with_file_paths.each do |model, file_path|
      CSV.read(file_path, headers: true).each do |row|
        row = framework_with_transformed_dates(row) if model == Framework

        record = model.find_by(id: row['id'])

        if record.present?
          record.update!(**row)
        else
          model.create!(**row)
        end
      end
    end
  end
end

namespace :db do
  desc 'add the frameworks into the database'
  task frameworks: :environment do
    puts 'Loading Frameworks'
    DistributedLocks.distributed_lock(151) do
      unless Rails.env.production?
        Frameworks.truncate_frameworks
        Frameworks.add_or_update_frameworks
      end
    end
  end

  task update_frameworks: :environment do
    puts 'Loading Framework updates'
    DistributedLocks.distributed_lock(152) do
      Frameworks.add_or_update_frameworks
    end
  end

  desc 'add static data to the database'
  task static: :frameworks
end
