module Cognito
  module Admin
    class Roles
      attr_reader :access, :available_roles

      attr_writer :roles, :service_access

      def initialize(access, roles, service_access)
        @access = access
        @roles = (roles || []).compact
        @service_access = (service_access || []).compact
        @available_roles = self.class.find_available_roles(access)
      end

      def role_selection_valid
        return :role_selection_required if @roles.empty?

        return :invalid_role_selection unless @roles.all? { |role| @available_roles.include?(role) }
      end

      def service_access_selection_valid
        return :invalid_service_access_selection unless @service_access.all? { |service_access| SERVICE_ROLES_ACCESS.include?(service_access) }

        return :service_access_selection_required if (@roles.include?('buyer') || @roles.include?('ccs_employee')) && @service_access.empty?
      end

      def combine_roles
        @service_access + @roles
      end

      def admin_roles_present?
        @roles.any? && @roles != ['buyer']
      end

      def application_role_locations
        return %i[main] if @roles.exclude?('buyer') && @roles.exclude?('ccs_employee')

        application_locations = []

        application_locations << :main if MAIN_SERVICE_ROLE_ACCESS.any? { |role| @service_access.include?(role) }
        application_locations << :legacy if LEGACY_SERVICE_ROLE_ACCESS.any? { |role| @service_access.include?(role) }

        application_locations
      end

      def self.get_roles_and_service_access_from_cognito_roles(cognito_roles)
        roles = SUPER_ADMIN_ROLE_ACCESS & cognito_roles
        service_access = SERVICE_ROLES_ACCESS & cognito_roles

        [roles, service_access]
      end

      def self.current_user_access(current_user_ability)
        if current_user_ability.can? :manage, FacilitiesManagement::Framework
          :super_admin
        elsif current_user_ability.can? :manage, AllowedEmailDomain
          :user_admin
        elsif current_user_ability.can? :read, AllowedEmailDomain
          :user_support
        end
      end

      def self.find_available_roles(access)
        case access
        when :super_admin
          SUPER_ADMIN_ROLE_ACCESS
        when :user_admin
          USER_ADMIN_ROLE_ACCESS
        when :user_support
          USER_SUPPORT_ROLE_ACCESS
        else
          []
        end
      end

      MAIN_SERVICE_ROLE_ACCESS = %w[fm_access].freeze
      LEGACY_SERVICE_ROLE_ACCESS = %w[st_access ls_access mc_access].freeze
      SERVICE_ROLES_ACCESS = (MAIN_SERVICE_ROLE_ACCESS + LEGACY_SERVICE_ROLE_ACCESS).freeze

      USER_SUPPORT_ROLE_ACCESS = %w[buyer].freeze
      USER_ADMIN_ROLE_ACCESS = (USER_SUPPORT_ROLE_ACCESS + %w[ccs_employee allow_list_access]).freeze
      SUPER_ADMIN_ROLE_ACCESS = (USER_ADMIN_ROLE_ACCESS + %w[ccs_user_admin]).freeze
    end
  end
end
