require 'transient_session_info'

module FacilitiesManagement
  class SummaryController < FrameworkController
    skip_before_action :verify_authenticity_token, only: :index

    require_permission :none, only: :index
    # :nocov:

    def index
      # puts 'SummaryController >> index'
      # @select_fm_locations = '/facilities-management/select-locations'
      # @select_fm_services = '/facilities-management/select-services'
      # @inline_error_summary_title = 'There was a problem'
      # @inline_error_summary_body_href = '#'
      # @inline_summary_error_text = 'You must select at least one longList before clicking the save continue button'

      @journey = Journey.new('summary', params)

      report

      respond_to do |format|
        format.js { render json: @branches.find { |branch| params[:daily_rate][branch.id].present? } }
        format.html
        format.xlsx do
          spreadsheet = Spreadsheet.new(@report, with_calculations: params[:calculations].present?)
          filename = "Shortlist of agencies#{params[:calculations].present? ? ' (with calculator)' : ''}"
          render xlsx: spreadsheet.to_xlsx, filename: filename
        end
      end
    end

    private

    def report
      start_date
      @report = SummaryReport.new(@start_date, current_login.email.to_s, TransientSessionInfo.tsi[session.id])
      @report.calculate_services_for_buildings
      regions
    end

    def start_date
      # @start_date = Date.new(@journey.params[:year].to_i, @journey.params[:month].to_i, @journey.params[:day].to_i)
    end

    def regions
      @posted_locations = TransientSessionInfo.tsi[session.id][:posted_locations]

      # Get nuts regions
      @regions = {}
      Nuts1Region.all.each { |x| @regions[x.code] = x.name }
      @subregions = {}
      FacilitiesManagement::Region.all.each { |x| @subregions[x.code] = x.name }
      @subregions.select! { |k, _v| @posted_locations.include? k }
    end
  end
end
