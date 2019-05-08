require 'transient_session_info'

module FacilitiesManagement
  class SummaryController < FrameworkController
    skip_before_action :verify_authenticity_token, only: :index

    require_permission :none, only: :index
    # :nocov:
    attr_accessor :start_date
    attr_accessor :current_lot
    attr_accessor :report

    def index
      # puts 'SummaryController >> index'
      # @select_fm_locations = '/facilities-management/select-locations'
      # @select_fm_services = '/facilities-management/select-services'
      # @inline_error_summary_title = 'There was a problem'
      # @inline_error_summary_body_href = '#'
      # @inline_summary_error_text = 'You must select at least one longList before clicking the save continue button'

      # @journey = Journey.new('summary', params)

      build_report

      respond_to do |format|
        format.js { render json: @branches.find { |branch| params[:daily_rate][branch.id].present? } }
        format.html
        format.xlsx do
          spreadsheet = Spreadsheet.new(@report, with_calculations: params[:calculations].present?)
          filename = "Shortlist of agencies#{params[:calculations].present? ? ' (with calculator)' : ''}"
          render xlsx: spreadsheet.to_xlsx, filename: filename
        end
      end
    rescue StandardError => e
      @message = e.message
      render 'error'
    end

    private

    def build_report
      set_start_date

      increase_current_lot if params['move-up-a-sublot'] == 'yes'

      puts @current_lot

      @report = SummaryReport.new(@start_date, current_login.email.to_s, TransientSessionInfo[session.id])
      @report.calculate_services_for_buildings
      regions
    end

    def set_start_date
      @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      TransientSessionInfo[session.id, :start_date] = @start_date
    rescue StandardError
      @start_date = TransientSessionInfo[session.id][:start_date]
    end

    # Lot.all_numberss
    def increase_current_lot
      current_lot = TransientSessionInfo[session.id][:current_lot]

      case current_lot
      when nil
        @current_lot = '1a'
      when '1a'
        @current_lot = '1b'
      when '1b'
        @current_lot = '1c'
      end
      TransientSessionInfo[session.id][:current_lot] = @current_lot
    end

    def regions
      @posted_locations = TransientSessionInfo[session.id][:posted_locations]

      # Get nuts regions
      @regions = {}
      Nuts1Region.all.each { |x| @regions[x.code] = x.name }
      @subregions = {}
      FacilitiesManagement::Region.all.each { |x| @subregions[x.code] = x.name }
      @subregions.select! { |k, _v| @posted_locations.include? k }
    end
  end
end
