require 'transient_session_info'

module FacilitiesManagement
  class SummaryController < FrameworkController
    skip_before_action :verify_authenticity_token, only: :create
    require_permission :none, only: :index
      # :nocov:

    def index

      @select_fm_locations = '/facilities-management/select-locations'
      @select_fm_services = '/facilities-management/select-services'
      @posted_locations = $tsi[session.id, :posted_locations]
      @posted_services = $tsi[session.id, :posted_services]
      @inline_error_summary_title = 'There was a problem'
      @inline_error_summary_body_href = '#'
      @inline_summary_error_text = 'You must select at least one longList before clicking the save continue button'


      # Get nuts regions
      # h = {}
      # Nuts1Region.all.each { |x| h[x.code] = x.name }
      # @regions = h
      h = {}
      FacilitiesManagement::Region.all.each { |x| h[x.code] = x.name }
      @subregions = h
      @subregions.select! { | k, v | @posted_locations.include? k }

      @supplier_count = $tsi[session.id, :supplier_count]

      @choice = params[:lot]
      case @choice # a_variable is the variable we want to compare
      when '1a'
        @suppliers_lot1a = $tsi[session.id, :suppliers_lot1a]
      when '1b'
        @suppliers_lot1b = $tsi[session.id, :suppliers_lot1b]
      when '1c'
        @suppliers_lot1c = $tsi[session.id, :suppliers_lot1c]
      else
        @suppliers_lot1a = $tsi[session.id, :suppliers_lot1a]
        @suppliers_lot1b = $tsi[session.id, :suppliers_lot1b]
        @suppliers_lot1c = $tsi[session.id, :suppliers_lot1c]
      end
    end

    # @supplier_count = [ @suppliers_lot1a, @suppliers_lot1b, @suppliers_lot1c ].max
    # puts @supplier_count
    puts 'SummaryController >> index'
  end

end
