module FacilitiesManagement
  class NewProcurementData
    include ActiveModel::Model
    include Virtus.model

    attribute :route_to_market
    attribute :confirm_direct_award
    attribute :select_an_invoicing_contact
    attribute :select_an_authorised_representative
    attribute :select_a_notice
    attribute :contract_not_signed
    attribute :contract_start_date
    attribute :contract_start_date_dd
    attribute :contract_start_date_mm
    attribute :contract_start_date_yyyy
    attribute :contract_end_date
    attribute :contract_end_date_dd
    attribute :contract_end_date_mm
    attribute :contract_end_date_yyyy
    attribute :name
    attribute :building
    attribute :street
    attribute :town_or_city
    attribute :county
    attribute :job_title
    attribute :email_address
    attribute :postcode
    attribute :telephone_number
    attribute :LGPS

    validates :route_to_market, inclusion: %w[direct further]
  end
end
