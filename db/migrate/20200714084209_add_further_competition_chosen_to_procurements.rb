class AddFurtherCompetitionChosenToProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :further_competition_chosen, :boolean, default: false
  end
end
