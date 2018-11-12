class SupplyTeachers::SuppliersController < ApplicationController
  def master_vendors
    @back_path = source_journey.current_step_path
    @suppliers = SupplyTeachers::Supplier.with_master_vendor_rates
  end

  def neutral_vendors
    @back_path = source_journey.current_step_path
    @suppliers = SupplyTeachers::Supplier.with_neutral_vendor_rates
  end

  private

  def source_journey
    SupplyTeachers::Journey.new('managed-service-provider', managed_service_provider_params)
  end

  def managed_service_provider_params
    params.permit(:looking_for, :managed_service_provider)
  end
end
