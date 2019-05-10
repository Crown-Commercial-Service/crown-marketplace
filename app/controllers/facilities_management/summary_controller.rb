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

    # helper :all
    helper_method %i[title suppliers_title lot_title]

    def title
      case @current_lot
      when nil
        'Review service without pricing'
      else
        'List of Suppliers'
      end
    end

    def suppliers_title
      count = @report.without_pricing.count

      str =
        if count == 1
          '<strong>' + count.to_s + ' supplier found </strong>'
        else
          '<strong>' + count.to_s + ' suppliers found </strong>'
        end

      count = @report.without_pricing.count + @report.with_pricing.count
      str <<
        if @current_lot.nil?
          ' (from ' + count.to_s + ' selected) without a price.'
        else
          ' to provide services in your regions.'
        end
      str.html_safe
    end

    def lot_title
      str =
      if @current_lot.nil?
        'Your suggested sub-lot at this time is: <strong>Lot 1a</strong>, subject to the contract value being up to £7m.'
      else
        "<p>Based on your requirements, here are the shortlisted suppliers.</p><p>Your selected sub-lot is <strong>Lot #{@current_lot}
        </strong>, subject to your total contract value and services without a price.</p>"
      end
      str.html_safe
    end

    def build_report
      set_start_date

      increase_current_lot if params['move-up-a-sublot'] == 'yes'

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
      TransientSessionInfo[session.id][:current_lot]

      @current_lot = move_upto_next_lot(TransientSessionInfo[session.id][:current_lot])

      TransientSessionInfo[session.id][:current_lot] = @current_lot
    end

    def move_upto_next_lot(lot)
      case lot
      when nil
        '1a'
      when '1a'
        '1b'
      when '1b'
        '1c'
      else
        lot
      end
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
