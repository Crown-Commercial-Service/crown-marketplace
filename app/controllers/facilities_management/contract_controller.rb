require 'facilities_management/fm_buildings_data'
require 'json'
class FacilitiesManagement::ContractController < ApplicationController
  require_permission :facilities_management, only: %i[start_of_contract].freeze

  def start_of_contract
    @start_form = 'About your contract'
  end
end
