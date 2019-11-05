class ChangeTimestampDefaultsFmRegions < ActiveRecord::Migration[5.2]
  def change
    if column_exists?(:fm_regions, :created_at)
      change_column_null :fm_regions, :created_at, true
      change_column_default :fm_regions, :created_at, from: '', to: 'now()'
    else
      add_column :fm_regions, :created_at, :datetime, from: '', to: 'now()', null: true
    end

    if column_exists?(:fm_regions, :updated_at)
      change_column_null :fm_regions, :updated_at, true
      change_column_default :fm_regions, :updated_at, from: '', to: 'now()'
    else
      add_column :fm_regions, :updated_at, :datetime, from: '', to: 'now()', null: true
    end
  end
end
