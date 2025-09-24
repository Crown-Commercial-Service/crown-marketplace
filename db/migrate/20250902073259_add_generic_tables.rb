class AddGenericTables < ActiveRecord::Migration[8.0]
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def change
    create_table :bank_holidays do |t|
      t.text :title
      t.date :date, index: true
      t.text :notes
      t.boolean :bunting

      t.timestamps
    end

    create_table :jurisdictions, id: :text do |t|
      t.text :name
      t.text :mapping_name

      t.timestamps
    end

    create_table :lots, id: :text do |t|
      t.references :framework, type: :text, foreign_key: true, index: true, null: false
      t.text :number, null: false
      t.text :name, null: false

      t.timestamps
    end

    create_table :services, id: :text do |t|
      t.references :lot, type: :text, foreign_key: true, index: true, null: false
      t.text :number, null: false
      t.text :name, null: false
      t.text :category

      t.timestamps
    end

    create_table :positions, id: :text do |t|
      t.references :lot, type: :text, foreign_key: true, index: true, null: false
      t.integer :number, null: false
      t.text :name, null: false
      t.text :category

      t.timestamps
    end

    create_table :searches, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: true, null: false
      t.references :framework, type: :text, foreign_key: true, index: true, null: false
      t.uuid :session_id
      t.text :search_criteria
      t.text :search_result

      t.timestamps
    end

    create_table :reports, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: true, null: false
      t.references :framework, type: :text, foreign_key: true, index: true, null: false
      t.string :aasm_state, limit: 30
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    create_table :uploads, id: :uuid do |t|
      t.references :framework, type: :text, foreign_key: true, index: true, null: false

      t.timestamps
    end

    create_table :suppliers, id: :uuid do |t|
      t.text :name, null: false
      t.text :duns_number
      t.boolean :sme

      t.timestamps

      t.index :name, unique: true
      t.index :duns_number, unique: true
    end

    create_table :supplier_frameworks, id: :uuid do |t|
      t.references :supplier, type: :uuid, foreign_key: true, index: true, null: false
      t.references :framework, type: :text, foreign_key: true, index: true, null: false
      t.boolean :enabled

      t.timestamps

      t.index %i[supplier_id framework_id], unique: true
    end

    create_table :supplier_framework_addresses, id: :uuid do |t|
      t.references :supplier_framework, type: :uuid, foreign_key: true, index: true, null: false
      t.text :address_line_1
      t.text :address_line_2
      t.text :town
      t.text :county
      t.text :postcode

      t.timestamps
    end

    create_table :supplier_framework_contact_details, id: :uuid do |t|
      t.references :supplier_framework, type: :uuid, foreign_key: true, index: true, null: false
      t.text :name
      t.text :email
      t.text :telephone_number
      t.text :website
      t.jsonb :additional_details

      t.timestamps
    end

    create_table :supplier_framework_lots, id: :uuid do |t|
      t.references :supplier_framework, type: :uuid, foreign_key: true, index: true, null: false
      t.references :lot, type: :text, foreign_key: true, index: true, null: false
      t.boolean :enabled

      t.timestamps

      t.index %i[supplier_framework_id lot_id], unique: true
    end

    create_table :supplier_framework_lot_branches, id: :uuid do |t|
      t.references :supplier_framework_lot, type: :uuid, foreign_key: true, index: true, null: false
      t.text :slug, index: true
      t.geography :location, limit: { srid: 4326, type: 'st_point', geographic: true }
      t.string :postcode, limit: 8, null: false
      t.text :contact_name
      t.text :contact_email
      t.text :telephone_number
      t.text :name
      t.text :town
      t.text :address_line_1
      t.text :address_line_2
      t.text :county
      t.text :region

      t.timestamps
    end

    create_table :supplier_framework_lot_services, id: :uuid do |t|
      t.references :supplier_framework_lot, type: :uuid, foreign_key: true, index: true, null: false
      t.references :service, type: :text, foreign_key: true, index: true, null: false

      t.timestamps

      t.index %i[supplier_framework_lot_id service_id], unique: true
    end

    create_table :supplier_framework_lot_jurisdictions, id: :uuid do |t|
      t.references :supplier_framework_lot, type: :uuid, foreign_key: true, index: true, null: false
      t.references :jurisdiction, type: :text, foreign_key: true, index: true, null: false

      t.timestamps

      t.index %i[supplier_framework_lot_id jurisdiction_id], unique: true
    end

    create_table :supplier_framework_lot_rates, id: :uuid do |t|
      t.references :supplier_framework_lot, type: :uuid, foreign_key: true, index: true, null: false
      t.references :position, type: :text, foreign_key: true, index: true, null: false
      t.references :supplier_framework_lot_jurisdiction, type: :uuid, foreign_key: true, index: true, null: false
      t.integer :rate, null: false

      t.timestamps

      t.index %i[supplier_framework_lot_id position_id supplier_framework_lot_jurisdiction_id], unique: true
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
