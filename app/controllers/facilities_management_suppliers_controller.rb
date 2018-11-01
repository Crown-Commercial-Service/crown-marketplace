class FacilitiesManagementSuppliersController < ApplicationController
  def index
    @journey = FacilitiesManagementJourney.new(params[:slug], params)
    @back_path = @journey.previous_step_path

    case params[:value_band]
    when 'under1_5m'
      small_lot
    when 'under7m'
      small_lot
    when 'under50m'
      big_lot '1b'
    when 'over50m'
      big_lot '1c'
    end
  end

  private

  def small_lot
    @lot = '1a'
    @suppliers = FacilitiesManagementSupplier.available_in_lot_and_regions(@lot, params[:region_codes])
  end

  def big_lot(lot)
    @lot = lot
    @suppliers = FacilitiesManagementSupplier.available_in_lot(@lot)
  end
end
