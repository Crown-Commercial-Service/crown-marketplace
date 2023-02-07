module FacilitiesManagement
  module Admin
    module SuppliersAdmin
      extend ActiveSupport::Concern

      included do
        validates :supplier_name, presence: true, uniqueness: true, length: { maximum: 100 }, on: :supplier_name

        validates :contact_name, :contact_email, :contact_phone, presence: true, on: :supplier_contact_information
        validates :contact_name, length: { maximum: 100 }, on: :supplier_contact_information
        validates :contact_email, email: { allow_nil: true }, on: :supplier_contact_information
        validates :contact_phone, format: { with: /\A(?:[ ()-]*\d){9,11}\z/ }, length: { maximum: 15 }, on: :supplier_contact_information

        validates :duns, :registration_number, presence: true, on: :additional_supplier_information
        validates :duns, format: { with: /\A\d{9}\z/ }, on: :additional_supplier_information
        validates :registration_number, format: { with: /\A([A-Z]{2}\d{6}|\d{6,8})\z/ }, on: :additional_supplier_information

        validates :address_line_1, length: { maximum: 100 }, presence: true, on: :supplier_address
        validates :address_line_2, length: { maximum: 100 }, on: :supplier_address
        validates :address_town, length: { maximum: 50 }, presence: true, on: :supplier_address
        validates :address_county, length: { maximum: 50 }, on: :supplier_address
        validates :address_postcode, presence: true, on: :supplier_address
        validate :postcode_format, if: -> { address_postcode.present? }, on: :supplier_address
      end

      def full_address
        [address_line_1, address_line_2, address_town, address_county].compact_blank.join(', ') + " #{address_postcode}"
      end

      private

      def postcode_format
        pc = UKPostcode.parse(address_postcode)
        pc.full_valid? ? errors.delete(:address_postcode) : errors.add(:address_postcode, :invalid)
      end
    end
  end
end
