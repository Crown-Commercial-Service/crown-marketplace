class Supplier < ApplicationRecord
  class Framework < ApplicationRecord
    class ContactDetail < ApplicationRecord
      belongs_to :supplier_framework, inverse_of: :contact_detail, class_name: 'Supplier::Framework'

      MAX_FIELD_LENGTH = 255
      ADDITIONAL_DETAILS_ATTRIBUTES = %i[address lot_1_prospectus_link lot_2_prospectus_link lot_3_prospectus_link lot_4a_prospectus_link lot_4b_prospectus_link lot_4c_prospectus_link lot_5_prospectus_link managed_service_provider_name managed_service_provider_telephone managed_service_provider_email].freeze

      store_accessor :additional_details, ADDITIONAL_DETAILS_ATTRIBUTES

      with_options on: %i[supplier_contact_information] do
        before_validation(:make_email_downcase, *%i[name email telephone_number website].map { |attribute| :"remove_excess_whitespace_from_#{attribute}" })

        validates :name, presence: true, length: { maximum: MAX_FIELD_LENGTH }, unless: -> { self.class::ATTRIBUTES_TO_SKIP_VALIDATION.include?(:name) }
        validates :email, presence: true, format: { with: /\A[^\s^@]+@[^\s^@]+\z/, message: :blank }, length: { maximum: MAX_FIELD_LENGTH }
        validates :telephone_number, presence: true, format: { with: /\A\d{11}\z|\A\d{5} \d{6}\z|\A\d{3} \d{4} \d{4}\z/, message: :blank }
        validates :website, presence: true, length: { maximum: MAX_FIELD_LENGTH }
        validate :website_is_a_valid_url, if: -> { errors[:website].none? }
      end

      with_options on: %i[additional_supplier_information] do
        before_validation(:make_managed_service_provider_email_downcase, *%i[address lot_1_prospectus_link lot_2_prospectus_link lot_3_prospectus_link lot_4a_prospectus_link lot_4b_prospectus_link lot_4c_prospectus_link lot_5_prospectus_link managed_service_provider_name managed_service_provider_telephone managed_service_provider_email].map { |attribute| :"remove_excess_whitespace_from_#{attribute}" })

        validates :address, presence: true, length: { maximum: MAX_FIELD_LENGTH }, unless: -> { self.class::ATTRIBUTES_TO_SKIP_VALIDATION.include?(:address) }

        %i[lot_1_prospectus_link lot_2_prospectus_link lot_3_prospectus_link lot_4a_prospectus_link lot_4b_prospectus_link lot_4c_prospectus_link lot_5_prospectus_link].each do |attribute|
          validates attribute, length: { maximum: MAX_FIELD_LENGTH }, unless: -> { self.class::ATTRIBUTES_TO_SKIP_VALIDATION.include?(attribute) }
          validate :"#{attribute}_is_a_valid_url", if: -> { public_send(attribute).present? && errors[attribute].none? }, unless: -> { self.class::ATTRIBUTES_TO_SKIP_VALIDATION.include?(attribute) }
        end

        validates :managed_service_provider_name, presence: true, length: { maximum: MAX_FIELD_LENGTH }, unless: -> { self.class::ATTRIBUTES_TO_SKIP_VALIDATION.include?(:managed_service_provider_name) }
        validates :managed_service_provider_email, presence: true, format: { with: /\A[^\s^@]+@[^\s^@]+\z/, message: :blank }, length: { maximum: MAX_FIELD_LENGTH }, unless: -> { self.class::ATTRIBUTES_TO_SKIP_VALIDATION.include?(:managed_service_provider_telephone) }
        validates :managed_service_provider_telephone, presence: true, format: { with: /\A\d{11}\z|\A\d{5} \d{6}\z|\A\d{3} \d{4} \d{4}\z/, message: :blank }, unless: -> { self.class::ATTRIBUTES_TO_SKIP_VALIDATION.include?(:managed_service_provider_email) }
      end

      def managed_service_provider
        {
          name: managed_service_provider_name,
          telephone: managed_service_provider_telephone,
          email: managed_service_provider_email
        }
      end

      private

      %i[name email telephone_number website address lot_1_prospectus_link lot_2_prospectus_link lot_3_prospectus_link lot_4a_prospectus_link lot_4b_prospectus_link lot_4c_prospectus_link lot_5_prospectus_link managed_service_provider_name managed_service_provider_telephone managed_service_provider_email].each do |attribute|
        define_method(:"remove_excess_whitespace_from_#{attribute}") { remove_excess_whitespace(attribute) }
      end

      %i[website lot_1_prospectus_link lot_2_prospectus_link lot_3_prospectus_link lot_4a_prospectus_link lot_4b_prospectus_link lot_4c_prospectus_link lot_5_prospectus_link].each do |attribute|
        define_method(:"#{attribute}_is_a_valid_url") { attribute_is_a_valid_url(attribute) }
      end

      %i[email managed_service_provider_email].each do |attribute|
        define_method(:"make_#{attribute}_downcase") { make_downcase(attribute) }
      end

      def remove_excess_whitespace(attribute)
        public_send(attribute)&.squish!
      end

      def make_downcase(attribute)
        public_send(attribute)&.downcase!
      end

      def attribute_is_a_valid_url(attribute)
        errors.add(attribute, :blank) unless url_valid?(public_send(attribute))
      end

      def url_valid?(url)
        uri = URI.parse(url)
        uri.is_a?(URI::HTTP) && uri.host.present?
      rescue URI::InvalidURIError
        false
      end
    end
  end
end
