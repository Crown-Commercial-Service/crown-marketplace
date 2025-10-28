class DeleteWrongLots < ActiveRecord::Migration[8.0]
  class Lots < ApplicationRecord
    self.table_name = 'lots'
  end

  class Services < ApplicationRecord
    self.table_name = 'services'
  end

  def up
    Services.where(lot_id: ['RM6378.2c', 'RM6378.3c']).destroy_all
    Lots.where(id: ['RM6378.2c', 'RM6378.3c']).destroy_all
  end

  def down; end
end
