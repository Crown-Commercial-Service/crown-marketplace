module FacilitiesManagement
  module RM6378
    module Admin
      class Supplier < ::Supplier
        self.table_name = 'suppliers'

        ATTRIBUTES_TO_SKIP_VALIDATION = %i[trading_name additional_identifier].freeze
      end
    end
  end
end
