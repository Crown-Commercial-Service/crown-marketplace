module FacilitiesManagement
  class SummaryReport
    include FacilitiesManagement::Beta::SummaryHelper

    attr_reader :sum_uom, :sum_benchmark, :building_data, :contract_length_years, :start_date, :tupe_flag, :posted_services, :posted_locations, :subregions, :errors

    def initialize(params)
      @sum_uom = 0
      @sum_benchmark = 0
      @errors = ''

      if params.is_a?(FacilitiesManagement::Procurement)
        @procurement = params
        initialize_from_procurement
      else
        @data = params[:data]
        @start_date = params[:start_date]
        @user_id = User.find_by(email: params[:user_email])&.id
        initialize_from_data
      end

      @rates ||= CCS::FM::Rate.read_benchmark_rates
      @rate_card ||= CCS::FM::RateCard.latest
      regions
    end

    def initialize_from_data
      @data.deep_symbolize_keys!

      @posted_services =
        if @data[:'fm-services']
          @data[:'fm-services'].collect { |x| x[:code].gsub('-', '.') }
        else
          @data[:posted_services]
        end

      @posted_locations = @data[:posted_locations]

      @contract_length_years = @data[:'fm-contract-length'].to_i
      @contract_cost = @data[:'fm-contract-cost'].to_f

      @tupe_flag = @data[:'is-tupe'] == 'yes'
    end

    def initialize_from_procurement
      @start_date = @procurement.initial_call_off_start_date
      @user_id = @procurement.user.id
      @posted_services = @procurement.procurement_building_services.map(&:code)
      @posted_locations = @procurement.active_procurement_buildings.map { |pb| pb.building['building_json']['address']['fm-address-region-code'] }
      @contract_length_years = @procurement.initial_call_off_period.to_i
      @contract_cost = @procurement.estimated_cost_known? ? @procurement.estimated_annual_cost.to_f : 0
      @tupe_flag = @procurement.tupe
    end

    # rubocop:disable Metrics/AbcSize
    def uvals_for_public(procurement_building, spreadsheet_type)
      procurement_building_services = procurement_building.procurement_building_services

      if spreadsheet_type == :da
        uvals_not_da = building_uvals.reject { |u| u[:code].in? CCS::FM::Service.direct_award_services }
        @errors = 'The following services are not Direct Award: ' + uvals_not_da.collect { |s| s[:service_code] }.to_s if uvals_not_da.count

        procurement_building_services = procurement_building_services.select { |u| u[:code].in? CCS::FM::Service.direct_award_services }
      elsif spreadsheet_type == :fc
        uvals_not_fc = building_uvals.reject { |u| u[:code].in? CCS::FM::Service.further_competition_services }
        @errors = 'The following services are not further Competition: ' + uvals_not_fc.collect { |s| s[:service_code] }.to_s if uvals_not_fc.count

        procurement_building_services = procurement_building_services.select { |u| u[:code].in? CCS::FM::Service.further_competition_services }
      end

      building_uvals = procurement_building_services.map do |procurement_building_service|
        {
          building_id: procurement_building.building_id,
          service_code: procurement_building_service.code,
          uom_value: procurement_building_service.uval,
          service_standard: procurement_building_service.service_standard
        }
      end
      [building_uvals, procurement_building.building.building_json]
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/ParameterLists (with a s)
    # rubocop:disable Metrics/AbcSize
    def calculate_services_for_buildings(selected_buildings, uvals = nil, supplier_name = nil, results = nil, remove_cafm_help = true, spreadsheet_type = nil)
      # selected_services

      @sum_uom = 0
      @sum_benchmark = 0
      uvals ||= uom_values(selected_buildings) unless

      selected_buildings.each do |building|
        if uvals
          building_json = building['building_json'].deep_symbolize_keys
          id = building_json[:id]
          building_uvals = (uvals.select { |u| u[:building_id] == id })
          building_data = building.building_json
          building_data.deep_symbolize_keys!
          building_uvals.map!(&:deep_symbolize_keys)

          # use .patition instead of select and reject
          uvals_not_da = uvals.reject { |u| u[:service_code].in? CCS::FM::Service.direct_award_services }
          @errors = 'The following services are not Direct Award: ' + uvals_not_da.collect { |s| s[:service_code] }.to_s if uvals_not_da.count

          building_uvals.select! { |u| u[:service_code].in? CCS::FM::Service.direct_award_services }
        else
          result = uvals_for_public(building, spreadsheet_type)
          all_building_uvals = result[0]
          building_data = result[1]
          id = result[0][0][:building_id]

          # TBC filter out nil values for now
          building_uvals = all_building_uvals.reject { |v| v[:uom_value].nil? }
        end

        # p "building id: #{id}"
        results2 = results[id] = {} if results

        vals_per_building = services(building_data, building_uvals, supplier_name, results2, remove_cafm_help)

        @sum_uom += vals_per_building[:sum_uom]
        @sum_benchmark += vals_per_building[:sum_benchmark] if supplier_name.nil?
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/ParameterLists (with a s)

    def selected_suppliers(for_lot)
      suppliers = CCS::FM::Supplier.all.select do |s|
        s.data['lots'].find do |l|
          (l['lot_number'] == for_lot) &&
            (@posted_locations & l['regions']).any? &&
            (@posted_services & l['services']).any?
        end
      end

      suppliers.sort_by! { |supplier| supplier.data['supplier_name'] }
    end

    # if services have no costings, just return the contract cost (do not divide the contract cost by 3 or 2)
    def assessed_value
      buyer_input = @contract_cost * @contract_length_years.to_f
      return buyer_input if buyer_input != 0.0 && @sum_uom == 0.0 && @sum_benchmark == 0.0

      return (@sum_uom + @sum_benchmark + buyer_input) / 3 unless buyer_input.zero?

      (@sum_uom + @sum_benchmark) / 2
    end

    def direct_award_value
      @sum_uom
    end

    def current_lot
      case assessed_value
      when 0..7000000
        '1a'
      when 7000000..50000000
        '1b'
      else # when > 50000000
        '1c'
      end
    end

    def lot_limit
      case assessed_value
      when 0..7000000
        '£7 Million'
      else # when 7000000..50000000
        '£50 Million'
      end
    end

    # rubocop:disable Metrics/AbcSize
    def uom_values(selected_buildings)
      uvals = CCS::FM::UnitOfMeasurementValues.values_for_user(@user_id)
      uvals = uvals.map(&:attributes)

      # add labels for spreadsheet
      uvals.each do |u|
        uoms = CCS::FM::UnitsOfMeasurement.service_usage(u['service_code'])
        u['title_text'] = uoms.last['title_text']
        u['example_text'] = uoms.last['example_text']
      end

      lift_service = uvals.select { |s| s['service_code'] == 'C.5' }
      if lift_service.count.positive?
        lifts_title_text = lift_service.last['title_text']
        lifts_example_text = lift_service.last['title_text']

        uvals.reject! { |u| u['service_code'] == 'C.5' && u['uom_value'] == 'Saved' }

        lifts_per_building.each do |b|
          b['lift_data']['lift_data']['floor-data'].each do |l|
            uvals << { user_id: b['user_id'],
                       service_code: 'C.5',
                       uom_value: l.first[1],
                       building_id: b['building_id'],
                       title_text: lifts_title_text,
                       example_text: lifts_example_text,
                       spreadsheet_label: 'The sum total of number of floors per lift' }
          end
        end
      end

      selected_buildings.each do |b|
        next unless b.building_json['services']

        b.building_json['services'].each do |s|
          # selected_services.each do |s|
          next unless CCS::FM::Service.gia_services.include? s['code']

          s_dot = s['code'].gsub('-', '.')
          uvals << { user_id: b['user_id'],
                     service_code: s_dot,
                     uom_value: b[:building_json]['gia'].to_f,
                     building_id: b[:building_json]['id'],
                     title_text: 'What is the total internal area of this building?',
                     example_text: 'For example, 18000 sqm. When the gross internal area (GIA) measures 18,000 sqm',
                     spreadsheet_label: 'Square Metre (GIA) per annum' }
        end
      end

      uvals
    end
    # rubocop:enable Metrics/AbcSize

    def lifts_per_building
      lifts_per_building = CCS::FM::Lift.lifts_for_user(@user_id)
      lifts_per_building.map(&:attributes)
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

    private

    # rubocop:disable Rails/FindEach
    def regions
      # Get nuts regions
      @subregions = {}
      FacilitiesManagement::Region.all.each { |x| @subregions[x.code] = x.name }
      @subregions.select! { |k, _v| posted_locations.include? k }
    end

    # rubocop:enable Rails/FindEach
    def copy_params(building_data, uvals)
      if @data
        @london_flag = building_data[:isLondon].present? && building_data[:isLondon] == true

        @cafm_flag ||= uvals.any? { |x| x[:service_code] == 'M.1' }

        @helpdesk_flag ||= uvals.any? { |x| x[:service_code] == 'N.1' }
      else
        @london_flag = building_in_london?(building_data['address']['fm-address-region-code'])
        procurement_building = @procurement.procurement_buildings.find_by(building_id: building_data['id'])
        @helpdesk_flag = procurement_building.procurement_building_services.where(code: 'N.1').any?
        @cafm_flag = procurement_building.procurement_building_services.where(code: 'M.1').any?
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/AbcSize
    def services(building_data, uvals, supplier_name = nil, results = nil, remove_cafm_help = true)
      sum_uom = 0.0
      sum_benchmark = 0.0

      copy_params building_data, uvals

      # TODO : Validation must be put in the front end to NOT allow just CAFM or HELP services otherwise an exception be ge generated below in .max
      uvals_remove_cafm_help = if remove_cafm_help == true
                                 uvals.reject { |x| x[:service_code] == 'M.1' || x[:service_code] == 'N.1' }
                               else

                                 uvals
                               end
      uvals_remove_cafm_help.each do |v|
        uom_value = calculate_uom_value(v)

        if v[:service_code] == 'G.3' || (v[:service_code] == 'G.1')
          occupants = v[:uom_value].to_i
          uom_value = (building_data[:gia] || building_data['gia']).to_f
        else
          occupants = 0
        end

        calc_fm = FMCalculator::Calculator.new(@contract_length_years,
                                               v[:service_code],
                                               uom_value,
                                               occupants,
                                               @tupe_flag,
                                               @london_flag,
                                               @cafm_flag,
                                               @helpdesk_flag,
                                               @rates,
                                               @rate_card,
                                               supplier_name,
                                               building_data)

        results2 = nil
        results2 = results[v[:service_code]] = {} if results
        results2[:spreadsheet_label] = v[:spreadsheet_label] if results2
        sum_uom += calc_fm.sumunitofmeasure results2
        sum_benchmark += calc_fm.benchmarkedcostssum if supplier_name.nil?
      end
      return { sum_uom: sum_uom } if supplier_name

      { sum_uom: sum_uom,
        sum_benchmark: sum_benchmark }
    rescue StandardError => e
      raise e
    ensure
      { sum_uom: sum_uom,
        sum_benchmark: sum_benchmark }
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    # london nuts are defined in FM-703
    def building_in_london?(code)
      %w[UKI3 UKI4 UKI5 UKI6 UKI7].include? code
    end
  end
end
