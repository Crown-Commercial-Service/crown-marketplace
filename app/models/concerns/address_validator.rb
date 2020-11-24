module AddressValidator
  extend ActiveSupport::Concern

  included do
    validates :organisation_address_line_1, length: { maximum: MAX_FIELD_LENGTH }, presence: true, on: NEW_ADDRESS_VALIDATIONS
    validates :organisation_address_line_2, length: { maximum: MAX_FIELD_LENGTH }, on: NEW_ADDRESS_VALIDATIONS
    validates :organisation_address_town, length: { maximum: MAX_FIELD_LENGTH }, presence: true, on: NEW_ADDRESS_VALIDATIONS
    validates :organisation_address_county, length: { maximum: MAX_FIELD_LENGTH }, on: NEW_ADDRESS_VALIDATIONS

    validates :organisation_address_postcode, presence: true, on: POSTCODE_VALIDATIONS
    validate :postcode_format, if: -> { organisation_address_postcode.present? }, on: POSTCODE_VALIDATIONS

    validate :address_selection, on: SELECT_ADDRESS_VALIDATIONS
  end

  private

  MAX_FIELD_LENGTH = 255

  NEW_ADDRESS_VALIDATIONS = %i[update_address new_invoicing_contact_details_address new_authorised_representative_address new_notices_contact_details_address].freeze

  POSTCODE_VALIDATIONS = %i[update_address update new_invoicing_contact_details_address new_authorised_representative_address new_notices_contact_details_address new_invoicing_contact_details new_authorised_representative new_notices_contact_details].freeze

  SELECT_ADDRESS_VALIDATIONS = %i[update new_invoicing_contact_details new_authorised_representative new_notices_contact_details].freeze

  def postcode_format
    pc = UKPostcode.parse(organisation_address_postcode)
    pc.full_valid? ? errors.delete(:organisation_address_postcode) : errors.add(:organisation_address_postcode, :invalid)
  end

  def address_selection
    return if errors[:organisation_address_postcode].any?

    errors.add(:base, :not_selected) if organisation_address_line_1.blank? || organisation_address_town.blank?
  end
end
