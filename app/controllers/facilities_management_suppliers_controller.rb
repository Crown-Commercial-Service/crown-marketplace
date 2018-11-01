class FacilitiesManagementSuppliersController < ApplicationController
  def index
    @journey = FacilitiesManagementJourney.new(params[:slug], params)
    @back_path = @journey.previous_step_path

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
  end
end
