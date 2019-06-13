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
      set_current_choices

      build_report

      respond_to do |format|
        format.js { render json: @branches.find { |branch| params[:daily_rate][branch.id].present? } }
        format.html
        format.xlsx do
          spreadsheet = Spreadsheet.new(@report, @current_lot, @data)
          render xlsx: spreadsheet.to_xlsx, filename: 'procurement_summary'
        end
      end
    rescue StandardError
      raise
    end

    private

    def set_current_choices
      super

      @data = TransientSessionInfo[session.id]
      # @supplier_count = @data['supplier_count']
      @current_lot = @data['current_lot']

      set_start_date
    end

    def workout_current_lot
      if @report.current_lot == '1c'
        @current_lot = '1c'
      elsif (params['sublot'] == 'no') || @report.without_pricing.count.zero?
        # check_current_lot
        @current_lot = @report.current_lot
      elsif params['sublot'] == 'yes'
        @current_lot = @report.move_upto_next_lot(@report.current_lot)
      end

      TransientSessionInfo[session.id]['current_lot'] = @current_lot
    end

    def build_report
      set_current_choices

      @report = SummaryReport.new(@start_date, current_login.email.to_s, TransientSessionInfo[session.id])
      @report.calculate_services_for_buildings

      workout_current_lot
    end

    def set_start_date
      @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      TransientSessionInfo[session.id, 'start_date'] = @start_date
      # TransientSessionInfo[session.id, 'current_lot'] = nil
    rescue StandardError
      @start_date = TransientSessionInfo[session.id]['start_date']
    end

    # Lot.all_numberss
    def check_current_lot
      @current_lot = @report.current_lot

      TransientSessionInfo[session.id]['current_lot'] = @current_lot
    end
  end
end
