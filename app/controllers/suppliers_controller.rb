class SuppliersController < ApplicationController
  def master_vendors
    @back_path = search_question_path(
      slug: 'managed-service-provider',
      params: managed_service_provider_params
    )
    @suppliers = Supplier.with_master_vendor_rates
  end

  def neutral_vendors
    @back_path = search_question_path(
      slug: 'managed-service-provider',
      params: managed_service_provider_params
    )
    @suppliers = Supplier.with_neutral_vendor_rates
  end

  private

  def managed_service_provider_params
    params.permit(:looking_for, :master_vendor)
  end
end
