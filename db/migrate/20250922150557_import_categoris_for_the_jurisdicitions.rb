class ImportCategorisForTheJurisdicitions < ActiveRecord::Migration[8.0]
  class Jurisdictions < ApplicationRecord
    self.table_name = 'jurisdictions'
  end

  JURISDICTIONS_FILE_PATH = Rails.root.join('data', 'jurisdictions.csv')

  def up
    CSV.read(JURISDICTIONS_FILE_PATH, headers: true).each do |row|
      record = Jurisdictions.find_by(id: row['id'])

      if record.present?
        record.update!(**row)
      else
        Jurisdictions.create!(**row)
      end
    end
  end

  def down; end
end
