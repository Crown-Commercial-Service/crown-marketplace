require 'csv'

module DataLoader::Frameworks
  class << self
    FRAMEWORKS_FILE_PATH = Rails.root.join('data', 'frameworks.csv')
    LOTS_FILE_PATH = Rails.root.join('data', 'lots.csv')
    SERVICES_FILE_PATH = Rails.root.join('data', 'services.csv')
    JURISDICTIONS_FILE_PATH = Rails.root.join('data', 'jurisdictions.csv')
    POSITIONS_FILE_PATH = Rails.root.join('data', 'positions.csv')

    private

    def models_with_file_paths
      [
        [Framework, FRAMEWORKS_FILE_PATH],
        [Lot, LOTS_FILE_PATH],
        [Service, SERVICES_FILE_PATH],
        [Jurisdiction, JURISDICTIONS_FILE_PATH],
        [Position, POSITIONS_FILE_PATH]
      ]
    end

    # rubocop:disable Metrics/AbcSize
    def framework_with_transformed_dates(framework)
      framework['live_at'] = Time.new(*framework['live_at'].split('-')).in_time_zone('London')
      framework['expires_at'] = Time.new(*framework['expires_at'].split('-')).in_time_zone('London')

      if Rails.env.test?
        case framework['id']
        when 'RM6238', 'RM6240', 'RM6309'
          framework['expires_at'] = 1.year.from_now
        when 'RM6232'
          framework['expires_at'] = 1.year.ago
        when 'RM6360', 'RM6378'
          framework['live_at'] = 1.year.ago
          framework['expires_at'] = 1.year.from_now
        end
      end

      framework
    end
    # rubocop:enable Metrics/AbcSize

    def truncate_frameworks
      ActiveRecord::Base.connection.truncate_tables(
        :frameworks,
        :lots,
        :services,
        :jurisdictions,
        :positions,
        :uploads,
        :searches,
        :reports,
        :procurements,
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

    def add_or_update_frameworks
      DistributedLocks.distributed_lock(151) do
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

    public

    def load_frameworks
      DistributedLocks.distributed_lock(151) do
        truncate_frameworks
        add_or_update_frameworks
      end
    end

    def update_frameworks
      DistributedLocks.distributed_lock(152) do
        add_or_update_frameworks
      end
    end
  end
end
