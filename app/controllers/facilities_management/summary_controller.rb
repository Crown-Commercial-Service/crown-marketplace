require 'transient_session_info'

module FacilitiesManagement
  class SummaryController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :index

    require_permission :none, only: :index
      # :nocov:

    def index

      puts 'SummaryController >> index'

      respond_to do |format|
        format.js { render json: @branches.find { |branch| params[:daily_rate][branch.id].present? } }
        format.html
        format.xlsx do
          spreadsheet = Spreadsheet.new(@branches, with_calculations: params[:calculations].present?)
          filename = "Shortlist of agencies#{params[:calculations].present? ? ' (with calculator)' : ''}"
          render xlsx: spreadsheet.to_xlsx, filename: filename
        end
      end

      @select_fm_locations = '/facilities-management/select-locations'
      @select_fm_services = '/facilities-management/select-services'
      @posted_locations = $tsi[session.id, :posted_locations]
      @posted_services = $tsi[session.id, :posted_services]
      @inline_error_summary_title = 'There was a problem'
      @inline_error_summary_body_href = '#'
      @inline_summary_error_text = 'You must select at least one longList before clicking the save continue button'


      # Get nuts regions
      h = {}
      Nuts1Region.all.each { |x| h[x.code] = x.name }
      @regions = h
      h = {}
      FacilitiesManagement::Region.all.each { |x| h[x.code] = x.name }
      @subregions = h
      @subregions.select! { | k, v | @posted_locations.include? k }


      @selected_services = FacilitiesManagement::Service.all.select { |service| @posted_services.include? service.code }
      # ------------------------------

      puts FacilitiesManagement::Service.all_codes
      puts FacilitiesManagement::Service.all
      puts FacilitiesManagement::Service.all.first.code
      puts FacilitiesManagement::Service.all.first.name
      puts FacilitiesManagement::Service.all.first.mandatory
      puts FacilitiesManagement::Service.all.first.mandatory?
      puts FacilitiesManagement::Service.all.first.work_package
      puts FacilitiesManagement::Service.all.first.work_package.code
      puts FacilitiesManagement::Service.all.first.work_package.name

      # ------------------------------

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

    calulate_fm
    calulate_fm_cleaning

  end

  private

  def calulate_fm
    puts 'calculate_fm'

  end

  def calulate_fm_cleaning
    puts 'calulate_fm_cleaning'

  end

end # module
