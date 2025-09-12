class MakeFrameworkPrimaryKey < ActiveRecord::Migration[8.0]
  class Frameworks < ApplicationRecord
    self.table_name = 'frameworks'
  end

  def up
    frameworks = Frameworks.all.map(&:attributes)

    drop_table :frameworks

    create_table 'frameworks', id: :text, force: :cascade do |t|
      t.text 'service'
      t.date 'live_at'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.date 'expires_at'
    end

    Frameworks.reset_column_information

    frameworks.each do |framework|
      Framework.create(
        id: framework['framework'],
        **framework.slice('service', 'live_at', 'expires_at')
      )
    end
  end

  def down
    frameworks = Frameworks.all.map(&:attributes)

    drop_table :frameworks

    create_table 'frameworks', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.string 'service', limit: 25
      t.string 'framework', limit: 6
      t.date 'live_at'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.date 'expires_at'
    end

    Frameworks.reset_column_information

    frameworks.each do |framework|
      Framework.create(
        framework: framework['id'],
        **framework.slice('service', 'live_at', 'expires_at')
      )
    end
  end
end
