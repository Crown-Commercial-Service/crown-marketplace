require 'facilities_management/fm_buildings_data'
require 'json'
class FacilitiesManagement::ContractController < FacilitiesManagement::FrameworkController
  before_action :authenticate_user!, only: %i[start_of_contract].freeze
  before_action :authorize_user, only: %i[start_of_contract].freeze

  def start_of_contract
    #
    # @journey = Journey.new(params[:slug], params)
    # @journey = FacilitiesManagement::Journey.new('contract-start', params)
    @start_form = 'About your contract'

    set_current_choices

    @next_page =
      if TransientSessionInfo[session.id]['env'] == 'public-beta'
        '/facilities-management/beta/summary'
      else
        '/facilities-management/summary'
      end
  end
end
