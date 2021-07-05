module FacilitiesManagement
  class Procurement < ApplicationRecord
    include ProcurementValidator

    has_many :optional_call_off_extensions, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :optional_call_off_extensions, allow_destroy: true

    has_many :procurement_buildings, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    has_many :active_procurement_buildings, -> { where(active: true) }, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementBuilding', inverse_of: :procurement, dependent: :destroy
    has_many :procurement_building_services, through: :active_procurement_buildings
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

    has_many :procurement_suppliers, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy

    has_one :spreadsheet_import, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy

    has_one :invoice_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementInvoiceContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :invoice_contact_detail, allow_destroy: true

    has_one :authorised_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementAuthorisedContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :authorised_contact_detail, allow_destroy: true

    has_one :notices_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementNoticesContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :notices_contact_detail, allow_destroy: true

    has_many :procurement_pension_funds, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy, index_errors: true, before_add: :before_each_procurement_pension_funds
    accepts_nested_attributes_for :procurement_pension_funds, allow_destroy: true, reject_if: :more_than_max_pensions?

    acts_as_gov_uk_date :initial_call_off_start_date, :security_policy_document_date, error_clash_behaviour: :omit_gov_uk_date_field_error

    has_one_attached :security_policy_document_file
  end
end
