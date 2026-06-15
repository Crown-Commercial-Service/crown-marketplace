require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'

class AddFrameworkToJurisdictions < ActiveRecord::Migration[8.1]
  JURISDICTIONS_FILE_PATH = Rails.root.join('data', 'jurisdictions.csv')

  class Frameworks < ApplicationRecord
    self.table_name = 'frameworks'
  end

  class Jurisdictions < ApplicationRecord
    self.table_name = 'jurisdictions'
  end

  class SupplierFrameworkLots < ApplicationRecord
    self.table_name = 'supplier_framework_lots'
  end

  class SupplierFrameworkLotJurisdictions < ApplicationRecord
    self.table_name = 'supplier_framework_lot_jurisdictions'
  end

  def add_new_jurisdictions
    Jurisdictions.import!(CSV.read(JURISDICTIONS_FILE_PATH, headers: true).map(&:to_h))
  end

  # rubocop:disable Rails/SkipsModelValidations
  def transform_supplier_framework_lot_jurisdictions(jurisdiction_code, framework_ids)
    framework_ids.each do |framework_id|
      SupplierFrameworkLotJurisdictions.where(jurisdiction_id: jurisdiction_code, supplier_framework_lot_id: SupplierFrameworkLots.where('lot_id LIKE ?', "#{framework_id}%").select(:id))
                                       .update_all(jurisdiction_id: "#{framework_id}.#{jurisdiction_code}")
    end
  end
  # rubocop:enable Rails/SkipsModelValidations

  def delete_old_jurisdictions
    jurisdiction_ids = CSV.read(JURISDICTIONS_FILE_PATH, headers: true).pluck('id')

    Jurisdictions.where.not(id: jurisdiction_ids).delete_all
  end

  def up
    add_reference :jurisdictions, :framework, type: :text, foreign_key: true, index: true
    add_column :jurisdictions, :code, :text

    add_new_jurisdictions

    framework_ids = Frameworks.pluck(:id)

    Jurisdictions.find_each { |jurisdiction| transform_supplier_framework_lot_jurisdictions(jurisdiction.code, framework_ids) }

    delete_old_jurisdictions

    # rubocop:disable Rails/BulkChangeTable
    change_column :jurisdictions, :framework_id, :text, null: false
    change_column :jurisdictions, :code, :text, null: false
    # rubocop:enable  Rails/BulkChangeTable
  end

  def down
    remove_reference :jurisdictions, :framework, type: :text, foreign_key: true, index: true
    remove_column :jurisdictions, :code
  end
end
