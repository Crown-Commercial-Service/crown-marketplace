module FacilitiesManagement
  module RM6378
    module Admin
      class SuppliersController < FacilitiesManagement::Admin::FrameworkController
        include ::Admin::SupplierActions
        include SectionsConcern
      end
    end
  end
end
