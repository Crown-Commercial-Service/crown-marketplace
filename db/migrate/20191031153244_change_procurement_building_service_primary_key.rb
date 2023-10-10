class ChangeProcurementBuildingServicePrimaryKey < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/DangerousColumnNames
  def up
    add_column :facilities_management_procurement_building_services, :uuid, :uuid, default: 'gen_random_uuid()', null: false

    change_table :facilities_management_procurement_building_services do |t|
      t.remove :id
      t.rename :uuid, :id
    end

    execute 'ALTER TABLE facilities_management_procurement_building_services ADD PRIMARY KEY (id);'
  end
  # rubocop:enable Rails/DangerousColumnNames
end
