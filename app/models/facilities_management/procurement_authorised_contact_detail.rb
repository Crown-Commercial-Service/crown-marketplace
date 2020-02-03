module FacilitiesManagement
  class ProcurementAuthorisedContactDetail < ProcurementContactDetail
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :authorised_contact_detail
    validates :telephone_number, presence: true, format: { with: /\A(\d{0,11})\z/ }, length: { maximum: 11 }
  end
end
