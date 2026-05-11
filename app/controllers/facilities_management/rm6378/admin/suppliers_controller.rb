module FacilitiesManagement
  module RM6378
    module Admin
      class SuppliersController < FacilitiesManagement::Admin::FrameworkController
        include ::Admin::SuppliersController

        SECTION_TO_PARAMS = {
          basic_supplier_information: %i[name duns_number sme],
        }.freeze
      end
    end
  end
end
