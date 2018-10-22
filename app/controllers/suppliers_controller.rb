class SuppliersController < ApplicationController
  def master_vendor_managed_service_providers
    @back_path = managed_service_provider_question_path(managed_service_provider_params)
    @suppliers = Supplier.with_master_vendor_rates
  end

  private

  def managed_service_provider_params
    params.permit(:hire_via_agency, :master_vendor)
  end
end
