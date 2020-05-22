module FacilitiesManagement
  class ProcurementContactDetail < ApplicationRecord
    validates :name, presence: true, length: { maximum: 50 }, on: %i[new_invoicing_contact_details new_authorised_representative_details new_notices_contact_details]
    validates :job_title, presence: true, length: { maximum: 150 }, on: %i[new_invoicing_contact_details new_authorised_representative_details new_notices_contact_details]
    validates :email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }, on: %i[new_invoicing_contact_details new_authorised_representative_details new_notices_contact_details]
    validates :organisation_address_postcode, presence: true, format: { with: /\A([a-zA-Z (0-9)]*)\z/ }, on: %i[new_invoicing_contact_details new_authorised_representative_details new_notices_contact_details new_invoicing_address new_authorised_representative_address new_notices_address]
    validate  :address_entered_when_postcode_provided, on: %i[new_invoicing_contact_details new_authorised_representative_details new_notices_contact_details]
    validate :valid_postcode?, on: %i[new_invoicing_contact_details new_authorised_representative_details new_notices_contact_details new_invoicing_address new_authorised_representative_address new_notices_address], if: -> { organisation_address_postcode.present? }

    validates :organisation_address_line_1, presence: true, on: %i[new_invoicing_address new_authorised_representative_address new_notices_address]
    validates :organisation_address_town, presence: true, on: %i[new_invoicing_address new_authorised_representative_address new_notices_address]

    def contact_address
      [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county].reject(&:nil?).reject(&:empty?).join(', ') + " #{organisation_address_postcode}"
    end

    def valid_contact_address?
      organisation_address_line_1&.present? && organisation_address_town&.present? && organisation_address_postcode&.present?
    end

    def full_name
      name
    end

    def full_organisation_address
      [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county].reject(&:nil?).reject(&:empty?).join(', ') + " #{organisation_address_postcode}"
    end

    def valid_postcode?
      return false if organisation_address_postcode.blank?

      pc = UKPostcode.parse(organisation_address_postcode)
      return true if pc.full_valid?

      errors.add(:organisation_address_postcode, :invalid)
      false
    end

    private

    def address_entered_when_postcode_provided
      errors.add(:organisation_address_postcode, :address_not_complete) unless valid_contact_address?
    end
  end
end
