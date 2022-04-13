module FacilitiesManagement
  module RM6232
    module Admin
      class SuppliersAdmin < ApplicationRecord
        self.table_name = 'facilities_management_rm6232_suppliers'

        include FacilitiesManagement::Admin::SuppliersAdmin

        validates :active, inclusion: { in: [true, false] }, on: :supplier_status

        def user_information_required?
          false
        end

        def suspendable?
          true
        end

        def current_status
          if active
            [:blue, 'ACTIVE']
          else
            [:red, 'INACTIVE']
          end
        end
      end
    end
  end
end
