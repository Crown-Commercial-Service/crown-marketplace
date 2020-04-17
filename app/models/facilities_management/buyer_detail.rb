module FacilitiesManagement
  class BuyerDetail < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buyer_detail

    validates :full_name, presence: true, on: :update
    validates :job_title, presence: true, on: :update
    validates :telephone_number, presence: true, format: { with: /\A(\d{0,11})\z/ }, on: :update
    validates :telephone_number, numericality: { greater_than: 0, message: :blank }, on: :update
    validates :organisation_name, presence: true, on: :update
    validates :organisation_address_postcode, presence: true, format: { with: /\A([a-zA-Z (0-9)]*)\z/ }, on: :update
    validate  :address_entered_when_postcode_provided, on: :update
    validates :central_government, inclusion: { in: [true, false], message: :blank }, on: :update

    validates :organisation_address_postcode, presence: true, format: { with: /\A([a-zA-Z (0-9)]*)\z/ }, on: :update_address
    validates :organisation_address_town, presence: true, on: :update_address
    validates :organisation_address_line_1, presence: true, on: :update_address

    delegate :email, to: :user

    def full_organisation_address
      [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county, organisation_address_postcode].reject(&:nil?).reject(&:empty?).join(', ')
    end

    private

    def address_entered_when_postcode_provided
      errors.add(:organisation_address_postcode, :address_not_complete) if organisation_address_line_1 == '' && organisation_address_town == '' && organisation_address_postcode != ''
    end
  end
end
