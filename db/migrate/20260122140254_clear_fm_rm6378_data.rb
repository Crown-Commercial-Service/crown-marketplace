class ClearFmRM6378Data < ActiveRecord::Migration[8.1]
  class Services < ApplicationRecord
    self.table_name = 'services'
  end

  class SupplierFrameworkLotServices < ApplicationRecord
    self.table_name = 'supplier_framework_lot_services'
  end

  def up
    SupplierFrameworkLotServices.where('service_id LIKE :prefix', prefix: 'RM6378%').destroy_all
    Services.where('lot_id LIKE :prefix', prefix: 'RM6378%').destroy_all
  end

  def down; end
end
