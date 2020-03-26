module FacilitiesManagement
  module Beta
    module Supplier
      class SentController < FacilitiesManagement::Beta::Supplier::FrameworkController
        def index
          @contract = ProcurementSupplier.find(params[:contract_id])
        end
      end
    end
  end
end
