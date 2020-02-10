module FacilitiesManagement
  class ProcurementContactDetail < ApplicationRecord
    validates :name, presence: true, format: { with: /\A([a-zA-Z\- ]*[\.]?[a-zA-Z\- ]*)\z/ }, length: { maximum: 50 }, on: :new_invoicing_contact_details :new_authorised_representative_details
    validates :job_title, presence: true, format: { with: /\A([a-zA-Z\- ]*)\z/ }, length: { maximum: 150 }, on: :new_invoicing_contact_details
    validates :email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }, on: :new_invoicing_contact_details
    validates :organisation_address_postcode, presence: true, format: { with: /\A([a-zA-Z (0-9)]*)\z/ }, on: :new_invoicing_contact_details
    validate  :address_entered_when_postcode_provided, on: :new_invoicing_contact_details

    validates :organisation_address_line_1, presence: true, format: { with: /\A([a-zA-Z\- (0-9)]*)\z/ }, on: :new_invoicing_address
    validates :organisation_address_town, presence: true, format: { with: /\A([a-zA-Z\- ]*)\z/ }, on: :new_invoicing_address
    validates :organisation_address_postcode, presence: true, format: { with: /\A([a-zA-Z (0-9)]*)\z/ }, on: :new_invoicing_address

    def contact_address
      "#{organisation_address_line_1}#{', ' + organisation_address_line_2 if organisation_address_line_2&.present?}#{', ' + organisation_address_town}#{', ' + organisation_address_county if organisation_address_county&.present?}#{', ' + organisation_address_postcode}"
    end

    def valid_contact_address?
      organisation_address_line_1&.present? && organisation_address_town&.present? && organisation_address_postcode&.present?
    end

    private

    def address_entered_when_postcode_provided
      errors.add(:organisation_address_postcode, :address_not_complete) unless valid_contact_address?
    end
  end
end
