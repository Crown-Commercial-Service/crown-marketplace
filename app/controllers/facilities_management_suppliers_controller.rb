class FacilitiesManagementSuppliersController < ApplicationController
  def index
    case params[:value_band]
    when 'under1_5m'
      @lot = '1a'
      @url = 'https://ccs-agreements.cabinetoffice.gov.uk/suppliers?sm_field_contract_id=%22RM3830%3A1a%22'
    when 'under7m'
      @lot = '1a'
      @url = 'https://ccs-agreements.cabinetoffice.gov.uk/suppliers?sm_field_contract_id=%22RM3830%3A1a%22'
    when 'under50m'
      @lot = '1b'
      @url = 'https://ccs-agreements.cabinetoffice.gov.uk/suppliers?sm_field_contract_id=%22RM3830%3A1b%22'
    when 'over50m'
      @lot = '1c'
      @url = 'https://ccs-agreements.cabinetoffice.gov.uk/suppliers?sm_field_contract_id=%22RM3830%3A1c%22'
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
