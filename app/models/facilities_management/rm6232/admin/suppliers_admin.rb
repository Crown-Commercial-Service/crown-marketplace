module FacilitiesManagement
  module RM6232
    module Admin
      class SuppliersAdmin < ApplicationRecord
        self.table_name = 'facilities_management_rm6232_suppliers'

        include FacilitiesManagement::Admin::SuppliersAdmin

        def user_information_required?
          false
        end
      end
    end
  end
end
