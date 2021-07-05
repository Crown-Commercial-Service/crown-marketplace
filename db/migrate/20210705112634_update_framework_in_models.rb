class UpdateFrameworkInModels < ActiveRecord::Migration[6.0]
  class Procurement < ApplicationRecord
    self.table_name = 'facilities_management_procurements'
  end

  # rubocop:disable Rails/SkipsModelValidations
  def up
    Procurement.reset_column_information
    Procurement.update_all(framework: 'RM3830')
  end
  # rubocop:enable Rails/SkipsModelValidations

  def down; end
end
