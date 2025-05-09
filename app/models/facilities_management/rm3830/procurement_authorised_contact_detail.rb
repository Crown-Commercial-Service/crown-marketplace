module FacilitiesManagement
  module RM3830
    class ProcurementAuthorisedContactDetail < ProcurementContactDetail
      belongs_to :procurement, class_name: 'FacilitiesManagement::RM3830::Procurement', foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :authorised_contact_detail
      validates :telephone_number, presence: true, format: { with: /\A[\s()\d-]{10,14}\d\z/ }, length: { maximum: 15 }, on: :new_authorised_representative
    end
  end
end
