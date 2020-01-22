module FacilitiesManagement
  class SummaryReport
    include FacilitiesManagement::Beta::SummaryHelper

    attr_reader :sum_uom, :sum_benchmark, :building_data, :contract_length_years, :start_date, :tupe_flag, :posted_services, :posted_locations, :subregions, :errors

    def initialize(start_date, user_id, data, procurement = nil)
      @errors = ''
      @start_date = start_date
      @user_id = user_id

      @sum_uom = 0
      @sum_benchmark = 0

      initialize_from_data data if data
      initialize_from_procurement procurement if procurement

      regions
    end

    def initialize_from_data(data)
      data.deep_symbolize_keys!

      @posted_services =
        if data[:'fm-services']
          data[:'fm-services'].collect { |x| x[:code].gsub('-', '.') }
        else
          data[:posted_services]
        end

      @posted_locations = data[:posted_locations]

      @contract_length_years = data[:'fm-contract-length'].to_i
      @contract_cost = data[:'fm-contract-cost'].to_f

      @tupe_flag =
        begin
          if data[:'is-tupe'] == 'yes'
            'Y'
          else
            'N'
          end
        rescue StandardError
          'N'
        end
    end

    # TBC check with Damola
    # what is the @contract_length_years ?
    def initialize_from_procurement(procurement)
      @posted_services = procurement[:service_codes]
      @posted_locations = procurement[:region_codes]
      @contract_length_years = procurement[:initial_call_off_period].to_i
      @contract_cost = procurement[:'fm-contract-cost'].to_f

      @tupe_flag = procurement[:tupe]
    end

    def user_buildings
      CCS::FM::Building.buildings_for_user(@user_id)
    end

    # rubocop:disable Metrics/AbcSize
    def uvals_for_public(building)
      building_uvals = building.procurement_building_services

      uvals_not_da = building_uvals.reject { |u| u[:code].in? CCS::FM::Service.direct_award_services }
      @errors = 'The following services are not Direct Award: ' + uvals_not_da.collect { |s| s[:service_code] }.to_s if uvals_not_da.count

      building_uvals = building_uvals.select { |u| u[:code].in? CCS::FM::Service.direct_award_services }

      # building_data = building
      building_data = FacilitiesManagement::Buildings.find_by(id: building.building_id).building_json
      services_and_questions = FacilitiesManagement::ServicesAndQuestions.new
      building_uvals = building_uvals.map do |u|
        # p u[:code]

        lookup = services_and_questions.service_detail(u[:code])
        value_field = lookup[:questions].reject { |v| v == :service_standard }

        val = u[value_field.first]
        val = building_data['gia'] if value_field.empty?
        val = u[value_field.first].map(&:to_i).inject(&:+) if value_field.first == :lift_data

        {
          # building_id: building.id,
          building_id: building.building_id,
          service_code: u[:code],
          uom_value: val
        }
      end
      [building_uvals, building_data]
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/ParameterLists (with a s)
    # rubocop:disable Metrics/AbcSize
    def calculate_services_for_buildings(selected_buildings, uvals = nil, rates = nil, rate_card = nil, supplier_name = nil, results = nil, remove_cafm_help = true)
      # selected_services

      @sum_uom = 0
      @sum_benchmark = 0

      # selected_buildings = user_buildings
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
          result = uvals_for_public(building)
          all_building_uvals = result[0]
          building_data = result[1]
          id = result[0][0][:building_id]

          # TBC filter out nil values for now
          building_uvals = all_building_uvals.reject { |v| v[:uom_value].nil? }
        end

        # p "building id: #{id}"
        results2 = results[id] = {} if results

        vals_per_building = services(building_data, building_uvals, rates, rate_card, supplier_name, results2, remove_cafm_help)
        @sum_uom += vals_per_building[:sum_uom]
        @sum_benchmark += vals_per_building[:sum_benchmark] if supplier_name.nil?
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/ParameterLists (with a s)

    def with_pricing
      # CCS::FM::Rate.non_zero_rate
      services_with_pricing = CCS::FM::Rate.non_zero_rate.map(&:code)

      services_selected = user_buildings.collect { |b| b.building_json['services'] }.flatten # s.collect { |s| s['code'].gsub('-', '.') }
      services_selected = services_selected.map { |s| s['code'] }
      services_selected.uniq!

      FacilitiesManagement::Service.all.select do |service|
        # (@posted_services.include? service.code) && (services_with_pricing.include? service.code)
        (services_selected.include? service.code) && (services_with_pricing.include? service.code)
      end
    end

    def without_pricing
      # CCS::FM::Rate.zero_rate
      services_without_pricing = CCS::FM::Rate.zero_rate.map(&:code)

      services_selected = user_buildings.collect { |b| b.building_json['services'] }.flatten # s.collect { |s| s['code'].gsub('-', '.') }
      services_selected = services_selected.map { |s| s['code'].gsub('-', '.') if s }
      services_selected = services_selected.uniq

      FacilitiesManagement::Service.all.select do |service|
        # (@posted_services.include? service.code) && (services_without_pricing.include? service.code)
        (services_selected.include? service.code) && (services_without_pricing.include? service.code)
      end
    end

    # usage:
    #   ["K.1", "K.5"]
    def list_of_services
      services_selected = user_buildings.collect { |b| b.building_json['services'] }.flatten # s.collect { |s| s['code'].gsub('-', '.') }
      services_selected = services_selected.map { |s| s['code'].gsub('-', '.') if s }.uniq

      services = FacilitiesManagement::Service.all.select { |service| services_selected.include? service.code }
      mandatory = FacilitiesManagement::Service.all.select { |service| service.code == 'A.18' || service.work_package_code == 'B' }
      services +
        mandatory <<
        FacilitiesManagement::Service.new(code: 'A.1 - A.17', name: 'Contract management', work_package_code: 'A', mandatory: true)
    end

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

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def copy_params(building_data, uvals)
      # Note: I think @fm_gross_internal_area can be removed as it is not used (also it does not work as :gia needs to be 'gia'
      @fm_gross_internal_area =
        begin
          building_data[:gia].to_i
        rescue StandardError
          0
        end

      @london_flag =
        begin
          # Note: a symbol is passed from rspec, and string key from the front end.I did not want to change too much.
          if (building_data[:isLondon] || building_data['isLondon']) == 'Yes'
            'Y'
          # TODO:  remove this line when postcode london logic is implemented
          elsif building_data['address']['fm-address-postcode'].downcase.gsub(/\s+/, '') == 'sw1a2aa'
            'Y'
          else
            'N'
          end
        rescue StandardError
          'N'
        end

      @cafm_flag =
        begin
          if uvals.any? { |x| x[:service_code] == 'M.1' }
            'Y'
          else
            'N'
          end
        rescue StandardError
          'N'
        end

      @helpdesk_flag =
        begin
          if uvals.any? { |x| x[:service_code] == 'N.1' }
            'Y'
          else
            'N'
          end
        rescue StandardError
          'N'
        end
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    # rubocop:disable Metrics/ParameterLists (with a s)
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/AbcSize
    def services(building_data, uvals, rates, rate_card = nil, supplier_name = nil, results = nil, remove_cafm_help = true)
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
                                               rates,
                                               rate_card,
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
    # rubocop:enable Metrics/ParameterLists (with a s)
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity
  end
end
