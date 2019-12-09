module FacilitiesManagement
  class NewProcurementData
    include ActiveModel::Model
    include Virtus.model

    attribute :route_to_market

    validates :route_to_market, inclusion: %w[direct further]
  end
end
