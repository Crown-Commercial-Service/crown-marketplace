module FacilitiesManagement
  class NewProcurementData
    include ActiveModel::Model
    include Virtus.model

    attribute :route_to_market
    attribute :confirm_direct_award
    attribute :name
    attribute :building
    attribute :street
    attribute :town_or_city
    attribute :county
    attribute :job_title
    attribute :email_address
    attribute :postcode
    attribute :telephone_number

    validates :route_to_market, inclusion: %w[direct further]
  end
end
