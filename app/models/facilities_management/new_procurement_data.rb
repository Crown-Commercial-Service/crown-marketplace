module FacilitiesManagement
  class NewProcurementData
    include ActiveModel::Model
    include Virtus.model

    attribute :route_to_market
    attribute :confirm_direct_award
    attribute :select_an_invoicing_contact

    validates :route_to_market, inclusion: %w[direct further]
  end
end
