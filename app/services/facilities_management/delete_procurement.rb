class FacilitiesManagement::DeleteProcurement
  def self.delete_porcurement(procurement)
    procurement_buildings = procurement.procurement_buildings
    procurement_buildings.each do |pb|
      procurement_building_services = pb.procurement_building_services
      procurement_building_services.each(&:delete)
      pb.delete
    end

    procurement.invoice_contact_detail&.delete

    procurement.authorised_contact_detail&.delete

    procurement.notices_contact_detail&.delete

    procurement_pension_funds = procurement.procurement_pension_funds
    procurement_pension_funds.each(&:delete)

    procurement_suppliers = procurement.procurement_suppliers
    procurement_suppliers.each(&:delete)

    rate_cards = CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement.id)
    rate_cards.each(&:delete)

    rates = CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement.id)
    rates.each(&:delete)

    procurement.destroy
  end
end
