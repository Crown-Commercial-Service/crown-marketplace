module FacilitiesManagement
  class BuyerDetail < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buyer_detail

    validates :full_name, presence: true, on: :update
    validates :job_title, presence: true, on: :update
    validates :telephone_number, presence: true, on: :update
    validates :telephone_number, numericality: { greater_than: 0, message: :blank }, on: :update
    validates :organisation_name, presence: true, on: :update
    validates :organisation_address_postcode, presence: true, on: :update
    validates :central_government, inclusion: { in: [true, false], message: :blank }, on: :update
  end
end
