module FacilitiesManagement
  module Beta
    module Admin
        class SupplierRatesController < FacilitiesManagement::Beta::FrameworkController
          def index
            @rates = FacilitiesManagement::Admin::Rates.all
            puts 'nooooooo'
          end
        end
      end
  end
end
