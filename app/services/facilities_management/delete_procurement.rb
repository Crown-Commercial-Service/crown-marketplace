class FacilitiesManagement::DeleteProcurement
  def self.delete_procurement(procurement)
    rate_cards = FacilitiesManagement::RM3830::FrozenRateCard.where(facilities_management_rm3830_procurement_id: procurement.id)
    rate_cards.each(&:delete)

    rates = FacilitiesManagement::RM3830::FrozenRate.where(facilities_management_rm3830_procurement_id: procurement.id)
    rates.each(&:delete)

    procurement.destroy
  end
end
