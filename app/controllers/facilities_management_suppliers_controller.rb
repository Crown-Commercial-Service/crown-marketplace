class FacilitiesManagementSuppliersController < ApplicationController
  def lot1a_suppliers
    @back_path = source_journey.current_step_path
    @suppliers = FacilitiesManagementSupplier.available_in_lot('1a')
  end

  def lot1b_suppliers
    @back_path = source_journey.current_step_path
    @suppliers = FacilitiesManagementSupplier.available_in_lot('1b')
  end

  def lot1c_suppliers
    @back_path = source_journey.current_step_path
    @suppliers = FacilitiesManagementSupplier.available_in_lot('1c')
  end

  private

  def source_journey
    FacilitiesManagementJourney.new('value-band', value_band_params)
  end

  def value_band_params
    params.permit(:value_band)
  end
end
