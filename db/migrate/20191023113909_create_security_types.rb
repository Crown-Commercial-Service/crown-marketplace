# rubocop:disable Style/GuardClause
class CreateSecurityTypes < ActiveRecord::Migration[5.2]
  def change
    unless table_exists?(:fm_security_types)
      create_table :fm_security_types do |t|
        t.uuid :id
        t.text :title
        t.text :description
        t.int :sort_order
        t.timestamps
      end
    end
  end
end
# rubocop:enable Style/GuardClause
