class ChangeTimestampDefaultsFmRegions < ActiveRecord::Migration[5.2]
  def change
    unless column_exists?(:fm_regions, :created_at)
      add_column :fm_regions, :created_at, :datetime, null: false
    end
    unless column_exists?(:fm_regions, :updated_at)
      add_column :fm_regions, :updated_at, :datetime, null: false
    end
    change_column_null :fm_regions, :created_at, true
    change_column_null :fm_regions, :updated_at, true

    change_column_default :fm_regions, :created_at, from: '', to: 'now()'
    change_column_default :fm_regions, :updated_at, from: '', to: 'now()'
  end
end
