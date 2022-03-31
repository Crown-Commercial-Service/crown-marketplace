# rubocop:disable Rails/ReversibleMigration
class ChangeLotToBeStringInManagementConsultancyRateCards < ActiveRecord::Migration[5.2]
  def change
    change_column :management_consultancy_rate_cards, :lot, :string
  end
end
# rubocop:enable Rails/ReversibleMigration
