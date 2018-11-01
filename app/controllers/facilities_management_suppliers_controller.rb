class FacilitiesManagementSuppliersController < ApplicationController
  def index
    case params[:value_band]
    when 'under1_5m'
      @lot = '1a'
    when 'under7m'
      @lot = '1a'
    when 'under50m'
      @lot = '1b'
    when 'over50m'
      @lot = '1c'
    end

    @suppliers = FacilitiesManagementSupplier.available_in_lot(@lot)
    @back_path = source_journey.current_step_path
  end

  private

  def source_journey
    FacilitiesManagementJourney.new('value-band', value_band_params)
  end

  def value_band_params
    params.permit(:value_band)
  end
end
