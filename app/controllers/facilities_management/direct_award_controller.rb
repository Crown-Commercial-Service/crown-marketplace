require 'facilities_management/fm_direct_award_calculator'
class FacilitiesManagement::DirectAwardController < ApplicationController
  require_permission :facilities_management, only: %i[calc_eligibility].freeze

  def calc_eligibility
    @building_type = params['building_type']
    @service_standard = params['service_standard']
    @priced_at_framework = params['priced_at_framework']
    @assessed_value = params['assessed_value']
    status = 200
    if @building_type.nil? || @priced_at_framework.nil? || @assessed_value.nil?
      j = { 'Error': 'Invalid parameter values' }
      status = 400
    else
      direct_award = DirectAward.new(@building_type, @service_standard, @priced_at_framework, @assessed_value)
      result = direct_award.calculate
      j = { 'building_type': @building_type, 'service_standard': @service_standard, 'priced_at_framework': @priced_at_framework, 'assessed_value': @assessed_value, 'Eligible': result }
    end
    render json: j, status: status
  end
end
