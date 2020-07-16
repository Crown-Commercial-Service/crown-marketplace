class FacilitiesManagement::DeleteProcurement
  def self.delete_procurement(procurement)
    rate_cards = CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement.id)
    rate_cards.each(&:delete)

    rates = CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement.id)
    rates.each(&:delete)

    procurement.destroy
  end
end
