class SetGoverningLaw < ActiveRecord::Migration[5.2]
  DEFAULT_LAW = 'english'.freeze

  def up
    FacilitiesManagement::Procurement.direct_award.where(governing_law: nil).find_each do |procurement|
      procurement.update(governing_law: DEFAULT_LAW)
    end

    FacilitiesManagement::Procurement.da_draft.where(governing_law: nil).find_each do |procurement|
      procurement.update(governing_law: DEFAULT_LAW) if %w[review_and_generate review sending sent].include?(procurement.da_journey_state)
    end
  end

  def down; end
end
