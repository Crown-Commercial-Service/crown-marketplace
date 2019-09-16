class ChangeTimestampDefaultsFmRegions < ActiveRecord::Migration[5.2]
  def change
    change_column_null :fm_regions, :created_at, true
    change_column_null :fm_regions, :updated_at, true

    change_column_default :fm_regions, :created_at, 'now()'
    change_column_default :fm_regions, :updated_at, 'now()'
  end
end
