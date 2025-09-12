class LoadFrameworkData < ActiveRecord::Migration[8.0]
  class Frameworks < ApplicationRecord
    self.table_name = 'frameworks'
  end

  class Lots < ApplicationRecord
    self.table_name = 'lots'
  end

  class Services < ApplicationRecord
    self.table_name = 'services'
  end

  class Jurisdictions < ApplicationRecord
    self.table_name = 'jurisdictions'
  end

  class Positions < ApplicationRecord
    self.table_name = 'positions'
  end

  FRAMEWORKS_FILE_PATH = Rails.root.join('data', 'frameworks.csv')
  LOTS_FILE_PATH = Rails.root.join('data', 'lots.csv')
  SERVICES_FILE_PATH = Rails.root.join('data', 'services.csv')
  JURISDICTIONS_FILE_PATH = Rails.root.join('data', 'jurisdictions.csv')
  POSITIONS_FILE_PATH = Rails.root.join('data', 'positions.csv')

  def models_with_file_paths
    [
      [Frameworks, FRAMEWORKS_FILE_PATH],
      [Lots, LOTS_FILE_PATH],
      [Services, SERVICES_FILE_PATH],
      [Jurisdictions, JURISDICTIONS_FILE_PATH],
      [Positions, POSITIONS_FILE_PATH]
    ]
  end

  def framework_with_transformed_dates(framework)
    framework['live_at'] = Time.new(*framework['live_at'].split('-')).in_time_zone('London')
    framework['expires_at'] = Time.new(*framework['expires_at'].split('-')).in_time_zone('London')

    framework
  end

  def up
    models_with_file_paths.each do |model, file_path|
      CSV.read(file_path, headers: true).each do |row|
        row = framework_with_transformed_dates(row) if model == Frameworks

        record = model.find_by(id: row['id'])

        if record.present?
          record.update!(**row)
        else
          model.create!(**row)
        end
      end
    end
  end

  def down; end
end
