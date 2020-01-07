module FacilitiesManagement
  class Supplier::Offer
    include ActiveModel::Model
    include Virtus.model

    attribute :respond_to_contract_offer
    attribute :contract_not_accepted
    attribute :contract_name
    attribute :contract_number
    attribute :buyer_name


  end
end
