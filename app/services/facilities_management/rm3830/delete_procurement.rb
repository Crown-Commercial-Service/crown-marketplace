module FacilitiesManagement::RM3830
  class DeleteProcurement
    def self.delete_procurement(procurement)
      rate_cards = FrozenRateCard.where(facilities_management_rm3830_procurement_id: procurement.id)
      rate_cards.each(&:delete)

      rates = FrozenRate.where(facilities_management_rm3830_procurement_id: procurement.id)
      rates.each(&:delete)

      procurement.destroy
    end
  end
end
