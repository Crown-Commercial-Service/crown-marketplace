class FacilitiesManagement::SuppliersController < ApplicationController
  def index
    @journey = FacilitiesManagement::Journey.new(params[:slug], params)
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
    @lot = FacilitiesManagement::Lot.find_by(number: '1a')
    @suppliers = FacilitiesManagement::Supplier.available_in_lot_and_regions(@lot.number, params[:region_codes])
  end

  def big_lot(lot_number)
    @lot = FacilitiesManagement::Lot.find_by(number: lot_number)
    @suppliers = FacilitiesManagement::Supplier.available_in_lot(@lot.number)
  end
end
