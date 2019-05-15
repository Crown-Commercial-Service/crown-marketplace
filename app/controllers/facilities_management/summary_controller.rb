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
      build_report

      respond_to do |format|
        format.js { render json: @branches.find { |branch| params[:daily_rate][branch.id].present? } }
        format.html
        format.xlsx do
          spreadsheet = Spreadsheet.new(@report)
          render xlsx: spreadsheet.to_xlsx, filename: 'procurement_summary'
        end
      end
    rescue StandardError => e
      raise e
    end

    private

    # helper :all
    helper_method %i[title services_and_suppliers_title lot_title list_services list_suppliers list_choices no_price_message]

    def title
      case @current_lot
      when nil
        "You have #{@report.without_pricing.count + @report.with_pricing.count} services selected"
      else
        'Shorlist of Suppliers'
      end
    end

    def services_title
      count = @report.without_pricing.count

      str = '<strong>However, '
      str <<
        if count == 1
          '1 service does '
        else
          "#{count} services do "
        end
      str << 'not have a price and we need you to estimate these costs'
    end

    def suppliers_title
      str = "<strong>#{@supplier_count} suppliers found</strong>"
      str << ' to provide the chosen services in your regions.'
      str << '<br/>'
      str << 'Your estimated cost is ' + ActiveSupport::NumberHelper.number_to_currency(@report.assessed_value, strip_insignificant_zeros: true) + " for the contract term of #{@report.contract_length_years} years."
    end

    def services_and_suppliers_title
      if @current_lot.nil?
        services_title
      else
        suppliers_title
      end
    end

    def lot_title
      return if @current_lot.nil?

      str = "<p>Based on your requirements, here are the shortlisted suppliers.</p><p>Your selected sub-lot is <strong>Lot #{@current_lot}
      </strong>, subject to your total contract value and services without a price.</p>"
      str << '<br/><p><strong>'
      str <<
        case @current_lot
        when '1a'
          'Total contract value up to £7m'
        when '1b'
          'Total contract value between £7m to £50m'
        when '1c'
          'Total contract value over £50m'
        end
      str << '</strong></p>'
    end

    def no_price_message
      "Suggested sub-lot <span style='display:inline-block; position: relative; left: 270px;'><strong>Lot #{@report.current_lot}</strong></span>"
    end

    def list_services
      if @current_lot.nil?
        str = '<p class="govuk-!-font-size-24"><strong>Services without pricing</strong><p/>'
        @report.without_pricing.each do |service|
          str << "<p>#{service.name}</p><hr style='width: 50%;margin-left: 0;border-style: dotted;'/>"
        end
      else
        str = "<p><strong>Services with pricing (#{@report.with_pricing.count}):</strong><p/>"
        @report.with_pricing.each do |service|
          str << "<p><strong>#{service.name}</strong></p><hr style='width: 50%;margin-left: 0;border-style: dotted;'/>"
        end
      end
      str
    end

    def list_suppliers
      str = "<p><strong>Lot #{@current_lot}</strong><p/>"

      suppliers = CCS::FM::Supplier.all.select do |s|
        s.data['lots'].find do |l|
          (l['lot_number'] == @current_lot) &&
            (@posted_locations & l['regions']).any? &&
            (@posted_services & l['services']).any?
        end
      end

      suppliers.sort_by! { |supplier| supplier.data['supplier_name'] }
      suppliers.each do |supplier|
        str << "<p>#{supplier.data['supplier_name']}</p><hr style='width: 50%;margin-left: 0;'/>"
      end
      str
    end

    def list_choices
      str = '<p><strong>Choices used to generate your shortlist:</strong></p>'
      str << '<p><strong>Filters used:</strong></p>'
      str << "<p>Regions (#{@subregions.count})</p>"
      @subregions.each do |location|
        str << '<p>'
        str << location[1]
        str << '</p>'
      end

      str << "<hr style='width: 50%;margin-left: 0;border-style: dotted;'/>"
      # FacilitiesManagement::Service.all
      services = FacilitiesManagement::Service.where(code: @posted_services)
      str << '<p>'
      str << "Services (#{services.count})"
      str << '</p>'
      services.sort_by!(&:code)
      services.each do |s|
        str << '<p>'
        str << s.name
        str << '</p>'
      end

      str
    end

    def set_current_choices
      TransientSessionInfo[session.id] = JSON.parse(params['current_choices']) if params['current_choices']
      data = TransientSessionInfo[session.id]
      @supplier_count = data['supplier_count']
      @posted_locations = data['posted_locations']
      @posted_services = data['posted_services']
      # @posted_locations ||= []
      # @posted_services ||= []

      set_start_date
    end

    def workout_current_lot
      if @report.current_lot == '1c'
        @current_lot = '1c'
      elsif (params['sublot'] == 'no') || @report.without_pricing.count.zero?
        # check_current_lot
        @current_lot = @report.current_lot
      elsif params['sublot'] == 'yes'
        @current_lot = move_upto_next_lot(@report.current_lot)
      end

      TransientSessionInfo[session.id]['current_lot'] = @current_lot
    end

    def build_report
      set_current_choices

      @report = SummaryReport.new(@start_date, current_login.email.to_s, TransientSessionInfo[session.id])
      @report.calculate_services_for_buildings

      workout_current_lot

      regions
    end

    def set_start_date
      @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      TransientSessionInfo[session.id, 'start_date'] = @start_date
      TransientSessionInfo[session.id, 'current_lot'] = nil
    rescue StandardError
      @start_date = TransientSessionInfo[session.id]['start_date']
    end

    # Lot.all_numberss
    def check_current_lot
      @current_lot = @report.current_lot

      TransientSessionInfo[session.id]['current_lot'] = @current_lot
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
      # Get nuts regions
      @regions = {}
      Nuts1Region.all.each { |x| @regions[x.code] = x.name }
      @subregions = {}
      FacilitiesManagement::Region.all.each { |x| @subregions[x.code] = x.name }
      @subregions.select! { |k, _v| @posted_locations.include? k }
    end
  end
end
