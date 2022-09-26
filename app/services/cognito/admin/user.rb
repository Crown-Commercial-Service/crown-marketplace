module Cognito
  module Admin
    class User < BaseService
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks

      attr_reader :email, :account_status, :confirmation_status, :mfa_enabled, :roles, :service_access, :cognito_roles, :telephone_number

      private

      attr_reader :origional_groups
      attr_writer :email, :telephone_number, :account_status, :confirmation_status
      attr_accessor :cognito_uuid

      public

      validates :email, presence: true, format: { with: /\A[^A-Z]*\z/ }, on: :create
      validate :domain_in_allow_list, if: -> { @cognito_roles.access == :user_support && email.present? }, on: :create

      validates :account_status, inclusion: { in: [true, false] }, on: :account_status

      validates :telephone_number, format: { with: /\A07\d{9}\z/ }, if: :telephone_number_required?, on: %i[create telephone_number]

      validates :roles, length: { is: 1 }, on: %i[select_role create]
      validate :validate_role, on: %i[create roles select_role]
      validate :can_set_admin_role, on: :roles

      validates :service_access, length: { minimum: 1 }, on: :service_access
      validate :validate_service_access, on: %i[create service_access]

      with_options on: :mfa_enabled do
        validate :can_set_mfa
        validates :mfa_enabled, inclusion: { in: [true, false] }
        validate :can_disable_mfa, unless: -> { mfa_enabled }
      end

      def self.find(current_user_access, cognito_uuid)
        new(current_user_access, UserClientInterface.find_user_from_cognito_uuid(cognito_uuid))
      end

      def self.search(email)
        return { users: [], error: 'You must enter an email address' } if email.blank?

        UserClientInterface.find_users_from_email(email.squish.downcase)
      end

      def initialize(current_user_access, attributes = {})
        assign_attributes(**attributes)

        return unless @error.nil?

        @cognito_roles = Roles.new(current_user_access, @roles, @service_access)
        @origional_groups = @cognito_roles.combine_roles
      end

      def assign_attributes(**new_attributes)
        raise ArgumentError, 'When assigning attributes, you must pass a hash as an argument.' unless new_attributes.respond_to?(:stringify_keys)
        return if new_attributes.empty?

        attributes = new_attributes.stringify_keys

        attributes.each do |key, value|
          setter = :"#{key}="

          raise ActiveRecord::UnknownAttributeError.new(self, key) unless respond_to?(setter, true)

          send(setter, value)
        end
      end

      def create
        return false unless valid?(:create)

        error = UserClientInterface.create_user_and_return_errors(cognito_attributes, cognito_roles.admin_roles_present?)

        errors.add(:base, error) if error

        error.nil?
      end

      def update(method)
        return false unless valid?(method)

        error = UserClientInterface.update_user_and_return_errors(cognito_uuid, cognito_attributes, method)

        errors.add(method, error) if error

        error.nil?
      end

      def success?
        errors.none?
      end

      private

      # Methods for assigning values to certain attributes
      %i[account_status mfa_enabled].each do |attribute|
        define_method :"#{attribute}=" do |value|
          instance_variable_set("@#{attribute}", ActiveModel::Type::Boolean.new.cast(value))
        end
      end

      %i[roles service_access].each do |attribute|
        define_method :"#{attribute}=" do |value|
          value = (value || []).compact

          @cognito_roles&.public_send("#{attribute}=", value)
          instance_variable_set("@#{attribute}", value)
        end
      end

      # Validations for the attributes
      def domain_in_allow_list
        return if AllowedEmailDomain.new(email_domain: email.split('@').last).domain_in_allow_list?

        errors.add(:email, :not_on_allow_list)
      end

      def telephone_number_required?
        return true if telephone_number.present? || validation_context == :telephone_number

        cognito_roles.admin_roles_present?
      end

      def validate_role
        role_error = cognito_roles.role_selection_valid

        errors.add(:roles, role_error) if role_error
      end

      def validate_service_access
        service_access_error = cognito_roles.service_access_selection_valid

        errors.add(:service_access, service_access_error) if service_access_error
      end

      def can_set_mfa
        errors.add(:mfa_enabled, :telephone_number_required) if telephone_number.blank?
      end

      def can_disable_mfa
        errors.add(:mfa_enabled, :cannot_disable_mfa) if cognito_roles.admin_roles_present?
      end

      def can_set_admin_role
        errors.add(:roles, :mfa_required) if !mfa_enabled && cognito_roles.admin_roles_present?
      end

      def cognito_attributes
        {
          email: email,
          account_status: account_status,
          telephone_number: telephone_number,
          groups: cognito_roles.combine_roles,
          origional_groups: origional_groups,
          mfa_enabled: mfa_enabled
        }
      end
    end
  end
end
