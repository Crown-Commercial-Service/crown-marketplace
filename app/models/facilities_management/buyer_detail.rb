module FacilitiesManagement
  class BuyerDetail < ApplicationRecord
    belongs_to :user, inverse_of: :buyer_detail

    attr_accessor :postcode_entry

    after_initialize do |bd|
      bd.postcode_entry = bd.organisation_address_postcode if bd.postcode_entry.blank?
    end

    MAX_FIELD_LENGTH = 255
    SECTORS = %w[culture_media_and_sport defence_and_security education government_policy health infrastructure local_community_and_housing].freeze

    validates :full_name, presence: true, length: { maximum: MAX_FIELD_LENGTH }, on: :update
    validates :job_title, presence: true, length: { maximum: MAX_FIELD_LENGTH }, on: :update
    validates :telephone_number, presence: true, format: { with: /\A[\s()\d-]{10,14}\d\z/ }, length: { maximum: 15 }, on: :update
    validates :telephone_number, numericality: { greater_than: 0, message: :blank }, on: :update
    validates :organisation_name, length: { maximum: MAX_FIELD_LENGTH }, presence: true, on: :update

    include AddressValidator

    validates :sector, inclusion: { in: SECTORS }, on: :update
    validates :contact_opt_in, inclusion: { in: [true, false] }, on: :update

    delegate :email, to: :user

    def full_organisation_address
      [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county].compact.reject(&:empty?).join(', ') + " #{organisation_address_postcode}"
    end

    def sector_name
      sector.nil? ? I18n.t("facilities_management.buyer_details.edit.central_government.options.#{central_government}") : I18n.t("facilities_management.buyer_details.edit.sector.options.#{sector}")
    end
  end
end
