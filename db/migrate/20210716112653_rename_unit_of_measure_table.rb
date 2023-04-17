class RenameUnitOfMeasureTable < ActiveRecord::Migration[6.0]
  class OldUnitOfMeasurement < ApplicationRecord
    self.table_name = :fm_units_of_measurement
  end

  class NewUnitOfMeasurement < ApplicationRecord
    self.table_name = :facilities_management_rm3830_units_of_measurements
  end

  # rubocop:disable Migration/RequireLimitOnString
  def up
    create_table 'facilities_management_rm3830_units_of_measurements', id: false, force: :cascade do |t|
      t.serial 'id', null: false
      t.string 'title_text', null: false
      t.string 'example_text'
      t.string 'unit_text'
      t.string 'data_type'
      t.string 'spreadsheet_label'
      t.string 'unit_measure_label'
      t.text 'service_usage', array: true
    end

    OldUnitOfMeasurement.reset_column_information
    NewUnitOfMeasurement.reset_column_information

    OldUnitOfMeasurement.all.each do |row|
      NewUnitOfMeasurement.create(row.attributes)
    end

    drop_table :fm_units_of_measurement

    Rails.logger.info 'RM3830 migrations complete'
  end

  def down
    create_table 'fm_units_of_measurement', id: false, force: :cascade do |t|
      t.serial 'id', null: false
      t.string 'title_text', null: false
      t.string 'example_text'
      t.string 'unit_text'
      t.string 'data_type'
      t.string 'spreadsheet_label'
      t.string 'unit_measure_label'
      t.text 'service_usage', array: true
    end

    OldUnitOfMeasurement.reset_column_information
    NewUnitOfMeasurement.reset_column_information

    NewUnitOfMeasurement.all.each do |row|
      OldUnitOfMeasurement.create(row.attributes)
    end

    drop_table :facilities_management_rm3830_units_of_measurements
  end
  # rubocop:enable Migration/RequireLimitOnString
end
