module FacilitiesManagement
  class ProcurementSupplier < ApplicationRecord
    default_scope { order(direct_award_value: :asc) }
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_suppliers

    def supplier
      CCS::FM::Supplier.find(supplier_id)
    end
  end
end
