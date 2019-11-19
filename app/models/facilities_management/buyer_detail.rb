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

    validates :organisation_address_postcode, presence: true, on: :update_address
    validates :organisation_address_town, presence: true, on: :update_address
    validates :organisation_address_line_1, presence: true, on: :update_address

    def full_organisation_address
      "#{organisation_address_line_1}#{', ' + organisation_address_line_2 if organisation_address_line_2.present?}#{', ' + organisation_address_town}#{', ' + organisation_address_county if organisation_address_county.present?}#{', ' + organisation_address_postcode}"
    end
  end
end
