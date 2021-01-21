module FacilitiesManagement
  module Admin
    class SuppliersAdmin < ApplicationRecord
      self.table_name = 'facilities_management_supplier_details'

      attr_accessor :user_email

      belongs_to :user, foreign_key: :user_id, inverse_of: :supplier_admin, optional: true

      validates :supplier_name, presence: true, uniqueness: true, length: { maximum: 100 }, on: :supplier_name

      validates :contact_email, :contact_name, :contact_phone, presence: true, on: :supplier_contact_information
      validates :contact_email, email: { allow_nil: true }, on: :supplier_contact_information
      validates :contact_name, length: { maximum: 100 }, on: :supplier_contact_information
      validates :contact_phone, format: { with: /\A(?:[ \(\)-]*\d){9,11}\z/ }, length: { maximum: 15 }, on: :supplier_contact_information

      validates :duns, :registration_number, presence: true, on: :additional_supplier_information
      validates :duns, format: { with: /\A\d{9}\z/ }, on: :additional_supplier_information
      validates :registration_number, format: { with: /\A([A-Z]{2}\d{6}|\d{6,8})\z/ }, on: :additional_supplier_information

      validates :address_line_1, length: { maximum: 100 }, presence: true, on: :supplier_address
      validates :address_line_2, length: { maximum: 100 }, on: :supplier_address
      validates :address_town, length: { maximum: 50 }, presence: true, on: :supplier_address
      validates :address_county, length: { maximum: 50 }, on: :supplier_address
      validates :address_postcode, presence: true, on: :supplier_address
      validate :postcode_format, if: -> { address_postcode.present? }, on: :supplier_address

      validates :user_email, email: true, on: :supplier_user
      validate :user_account_validation, on: :supplier_user

      def replace_services_for_lot(new_services, target_lot)
        lot_data[target_lot]['services'] = new_services || []
      end

      def full_address
        [address_line_1, address_line_2, address_town, address_county].reject(&:blank?).join(', ') + " #{address_postcode}"
      end

      private

      def postcode_format
        pc = UKPostcode.parse(address_postcode)
        pc.full_valid? ? errors.delete(:address_postcode) : errors.add(:address_postcode, :invalid)
      end

      USER_ACCOUNT_VALIDATIONS = { account_must_exist: :user_exists?, account_must_be_supplier: :user_supplier?, account_must_be_unique: :user_unique? }.freeze

      def user_account_validation
        USER_ACCOUNT_VALIDATIONS.each do |error, validation|
          break if errors[:user_email].any?

          errors.add(:user_email, error) unless send(validation)
        end
      end

      def user_exists?
        self.user = User.find_by(email: user_email)
        user.present?
      end

      def user_supplier?
        user.has_role? :supplier
      end

      def user_unique?
        self.class.where.not(supplier_id: supplier_id).pluck(:user_id).exclude? user.id
      end
    end
  end
end
