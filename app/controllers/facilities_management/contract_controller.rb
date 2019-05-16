require 'facilities_management/fm_buildings_data'
require 'json'
class FacilitiesManagement::ContractController < ApplicationController
  require_permission :facilities_management, only: %i[start_of_contract].freeze

  def start_of_contract
    #
    # @journey = Journey.new(params[:slug], params)
    # @journey = FacilitiesManagement::Journey.new('contract-start', params)
    @start_form = 'About your contract'

    set_current_choices
  end

  def set_current_choices
    TransientSessionInfo[session.id] = JSON.parse(params['current_choices']) if params['current_choices']
  end
end
