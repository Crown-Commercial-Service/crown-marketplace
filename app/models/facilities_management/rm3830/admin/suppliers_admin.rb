module FacilitiesManagement
  module RM3830
    module Admin
      class SuppliersAdmin < ApplicationRecord
        self.table_name = 'facilities_management_rm3830_supplier_details'

        include FacilitiesManagement::Admin::SuppliersAdmin

        attr_accessor :user_email

        belongs_to :user, inverse_of: :supplier_admin, optional: true

        validates :user_email, email: true, on: :supplier_user
        validate :user_account_validation, on: :supplier_user

        def user_information_required?
          true
        end

        def suspendable?
          false
        end

        def replace_services_for_lot(new_services, target_lot)
          lot_data[target_lot]['services'] = new_services || []
        end

        private

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
          self.class.where.not(supplier_id:).pluck(:user_id).exclude? user.id
        end
      end
    end
  end
end
