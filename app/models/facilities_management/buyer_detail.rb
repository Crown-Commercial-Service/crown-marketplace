module FacilitiesManagement
  class BuyerDetail < ApplicationRecord
    belongs_to :user, inverse_of: :buyer_detail

    attr_accessor :postcode_entry

    after_initialize do |bd|
      bd.postcode_entry = bd.organisation_address_postcode if bd.postcode_entry.blank?
    end

    MAX_FIELD_LENGTH = 255

    validates :full_name, presence: true, length: { maximum: MAX_FIELD_LENGTH }, on: :update
    validates :job_title, presence: true, length: { maximum: MAX_FIELD_LENGTH }, on: :update
    validates :telephone_number, presence: true, format: { with: /\A[\s()\d-]{10,14}\d\z/ }, length: { maximum: 15 }, on: :update
    validates :telephone_number, numericality: { greater_than: 0, message: :blank }, on: :update
    validates :organisation_name, length: { maximum: MAX_FIELD_LENGTH }, presence: true, on: :update

    include AddressValidator

    validates :central_government, inclusion: { in: [true, false] }, on: :update
    validates :contact_opt_in, inclusion: { in: [true, false] }, on: :update

    delegate :email, to: :user

    def full_organisation_address
      [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county].compact.reject(&:empty?).join(', ') + " #{organisation_address_postcode}"
    end
  end
end
