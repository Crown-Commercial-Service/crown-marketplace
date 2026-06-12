module FacilitiesManagement
  class BuyerDetail < ApplicationRecord
    belongs_to :user, inverse_of: :buyer_detail

    MAX_FIELD_LENGTH = 255
    SECTORS = %w[culture_media_and_sport defence_and_security education government_policy health infrastructure local_community_and_housing].freeze

    with_options on: %i[update personal_details] do
      validates :full_name, presence: true, length: { maximum: MAX_FIELD_LENGTH }

      validates :job_title, presence: true, length: { maximum: MAX_FIELD_LENGTH }

      validates :telephone_number, presence: true, format: { with: /\A[\s()\d-]{10,14}\d\z/ }, length: { maximum: 15 }
      validates :telephone_number, numericality: { greater_than: 0, message: :blank }
    end

    with_options on: %i[update organisation_details] do
      validates :organisation_name, length: { maximum: MAX_FIELD_LENGTH }, presence: true

      validates :organisation_address_line_1, length: { maximum: MAX_FIELD_LENGTH }, presence: true

      validates :organisation_address_line_2, length: { maximum: MAX_FIELD_LENGTH }

      validates :organisation_address_town, length: { maximum: MAX_FIELD_LENGTH }, presence: true

      validates :organisation_address_county, length: { maximum: MAX_FIELD_LENGTH }

      validates :organisation_address_postcode, presence: true

      validate :postcode_format, if: -> { organisation_address_postcode.present? }

      validates :sector, inclusion: { in: SECTORS }
    end

    with_options on: %i[update contact_preferences] do
      validates :contact_opt_in, inclusion: { in: [true, false] }
    end

    delegate :email, to: :user

    def full_organisation_address
      [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county].compact.reject(&:empty?).join(', ') + " #{organisation_address_postcode}"
    end

    def sector_name
      sector.nil? ? I18n.t("facilities_management.buyer_details.sections.organisation_details.sector.options.#{central_government}") : I18n.t("facilities_management.buyer_details.sections.organisation_details.sector.options.#{sector}")
    end

    def details_complete?
      valid?(:update)
    end

    private

    def postcode_format
      postcode = UKPostcode.parse(organisation_address_postcode)

      postcode.full_valid? ? errors.delete(:organisation_address_postcode) : errors.add(:organisation_address_postcode, :invalid)
    end
  end
end
