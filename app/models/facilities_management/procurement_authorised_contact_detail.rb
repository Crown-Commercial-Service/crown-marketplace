module FacilitiesManagement
  class ProcurementAuthorisedContactDetail < ProcurementContactDetail
    before_validation :remove_whitespace_from_telephone_number
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :authorised_contact_detail
    validates :telephone_number, presence: true, format: { with: /\A[\s()\d-]{10,14}\d\z/ }, length: { maximum: 15 }
    private
    def remove_whitespace_from_telephone_number
      self.name = name&.split&.join(' ')
    end
  end
end