require 'transient_session_info'

module FacilitiesManagement
  class SummaryController < FacilitiesManagement::FrameworkController
    skip_before_action :verify_authenticity_token
    # protect_from_forgery with: :exception
    before_action :authenticate_user!, except: :index
    before_action :authorize_user, except: :index

    # :nocov:
    attr_accessor :start_date
    attr_accessor :current_lot
    attr_accessor :report

    def index
      set_current_choices

      build_report

      respond_to do |format|
        format.json { render json: { result: "summary page: #{@data['env']}" } }
        format.html do
          render 'facilities_management/beta/summary/index' if @data['env'] == 'public-beta'
          # render default private beta template if 'public-beta' is not set
        end
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

      user_email = current_user.email.to_s

      @report = SummaryReport.new(@start_date, user_email, TransientSessionInfo[session.id])

      selected_buildings = CCS::FM::Building.buildings_for_user(user_email)

      uvals = @report.uom_values(selected_buildings)

      # move this into the model
      @report.calculate_services_for_buildings selected_buildings,
                                               uvals,
                                               CCS::FM::Rate.read_benchmark_rates

      workout_current_lot
    end

    def set_start_date
      @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      TransientSessionInfo[session.id, 'start_date'] = @start_date
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
