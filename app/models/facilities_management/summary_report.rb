module FacilitiesManagement
  class SummaryReport
    include FacilitiesManagement::Beta::SummaryHelper

    attr_reader :sum_uom, :sum_benchmark, :building_data, :contract_length_years, :start_date, :tupe_flag, :posted_services, :posted_locations, :subregions, :results

    def initialize(procurement_id)
      @sum_uom = 0
      @sum_benchmark = 0
      @procurement = FacilitiesManagement::Procurement.find(procurement_id)
      initialize_from_procurement

      frozen_rates = CCS::FM::FrozenRate.where(facilities_management_procurement_id: procurement_id)
      @rates = frozen_rates.read_benchmark_rates unless frozen_rates.size.zero?
      @rates = CCS::FM::Rate.read_benchmark_rates if frozen_rates.size.zero?

      frozen_ratecard = CCS::FM::FrozenRateCard.where(facilities_management_procurement_id: procurement_id)
      @rate_card = frozen_ratecard.latest unless frozen_ratecard.size.zero?
      @rate_card = CCS::FM::RateCard.latest if frozen_ratecard.size.zero?
      regions
    end

    def initialize_from_procurement
      @start_date = @procurement.initial_call_off_start_date
      @user_id = @procurement.user.id
      @posted_services = @procurement.procurement_building_services.map(&:code)
      @posted_locations = @procurement.active_procurement_buildings.map { |pb| pb.building.address_region_code }
      @contract_length_years = @procurement.initial_call_off_period.to_i
      @contract_cost = @procurement.estimated_cost_known? ? @procurement.estimated_annual_cost.to_f : 0
      @tupe_flag = @procurement.tupe
    end

    def calculate_services_for_buildings(supplier_name = nil, remove_cafm_help = true, spreadsheet_type = nil)
      @sum_uom = 0
      @sum_benchmark = 0
      @results = {}

      @procurement.active_procurement_buildings.each do |building|
        result = uvals_for_building(building, spreadsheet_type)
        building_data = result[1]
        # TBC filter out nil values for now
        building_uvals = result[0].reject { |v| v[:uom_value].nil? }

        vals_per_building = services(building_data, building_uvals, supplier_name, remove_cafm_help)
        @sum_uom += vals_per_building[:sum_uom]
        @sum_benchmark += vals_per_building[:sum_benchmark] if supplier_name.nil?

        # for da spreadsheet
        @results[building.building_id] = vals_per_building[:results] if supplier_name
      end
    end

    def selected_suppliers(for_lot)
      suppliers = CCS::FM::Supplier.all.select do |s|
        s.data['lots'].find do |l|
          (l['lot_number'] == for_lot) &&
            (@posted_locations - l['regions']).empty? &&
            (@posted_services - l['services']).empty?
        end
      end

      suppliers.sort_by! { |supplier| supplier.data['supplier_name'] }
    end

    def assessed_value
      @assessed_value ||= calculate_assessed_value
    end

    def direct_award_value
      @sum_uom
    end

    def buyer_input
      @buyer_input ||= @contract_cost * @contract_length_years.to_f
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

    def uvals_for_building(building, spreadsheet_type = nil)
      services = case spreadsheet_type
                 when :da
                   da_procurement_building_services(building)
                 when :fc
                   fc_procurement_building_services(building)
                 else
                   building.procurement_building_services
                 end

      building_uvals = services.map do |procurement_building_service|
        {
          building_id: building.building_id,
          service_code: procurement_building_service.code,
          uom_value: procurement_building_service.uval,
          service_standard: procurement_building_service.service_standard
        }
      end
      [building_uvals, building.building.building_json]
    end

    def da_procurement_building_services(building)
      building.procurement_building_services.select { |u| u.code.in? CCS::FM::Service.direct_award_services(@procurement.id) }
    end

    def fc_procurement_building_services(building)
      building.procurement_building_services.select { |u| u.code.in? CCS::FM::Service.further_competition_services(@procurement.id) }
    end

    # rubocop:disable Metrics/AbcSize
    def uom_values(spreadsheet_type)
      uvals = @procurement.active_procurement_buildings.map { |building| uvals_for_building(building, spreadsheet_type) }

      # add labels for spreadsheet
      uvals.each do |u|
        uoms = CCS::FM::UnitsOfMeasurement.service_usage(u['service_code'])
        u['title_text'] = uoms.last['title_text']
        u['example_text'] = uoms.last['example_text']
      end

      # lift_service = uvals.select { |s| s['service_code'] == 'C.5' }
      # if lift_service.count.positive?
      #   lifts_title_text = lift_service.last['title_text']
      #   lifts_example_text = lift_service.last['title_text']
      #
      #   uvals.reject! { |u| u['service_code'] == 'C.5' && u['uom_value'] == 'Saved' }
      #
      #   lifts_per_building.each do |b|
      #     b['lift_data']['lift_data']['floor-data'].each do |l|
      #       uvals << { user_id: b['user_id'],
      #                  service_code: 'C.5',
      #                  uom_value: l.first[1],
      #                  building_id: b['building_id'],
      #                  title_text: lifts_title_text,
      #                  example_text: lifts_example_text,
      #                  spreadsheet_label: 'The sum total of number of floors per lift' }
      #     end
      #   end
      # end

      @procurement.active_procurement_buildings.each do |b|
        b.procurement_building_services.each do |s|
          # selected_services.each do |s|
          next unless CCS::FM::Service.gia_services.include? s.code

          uvals << { user_id: @procurement.user.id,
                     service_code: s.code.gsub('-', '.'),
                     uom_value: b.building.gia.to_f,
                     building_id: b.building_id,
                     title_text: 'What is the total internal area of this building?',
                     example_text: 'For example, 18000 sqm. When the gross internal area (GIA) measures 18,000 sqm',
                     spreadsheet_label: 'Square Metre (GIA) per annum' }
        end
      end

      uvals
    end
    # rubocop:enable Metrics/AbcSize

    private

    # rubocop:disable Rails/FindEach
    def regions
      # Get nuts regions
      @subregions = {}
      FacilitiesManagement::Region.all.each { |x| @subregions[x.code] = x.name }
      @subregions.select! { |k, _v| posted_locations.include? k }
    end
    # rubocop:enable Rails/FindEach

    def copy_params(building_data, _uvals)
      @london_flag = building_in_london?(building_data[:address]['fm-address-region-code'.to_sym])
      procurement_building = @procurement.procurement_buildings.find_by(building_id: building_data[:id])
      @helpdesk_flag = procurement_building.procurement_building_services.where(code: 'N.1').any?
      @cafm_flag = procurement_building.procurement_building_services.where(code: 'M.1').any?
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/AbcSize
    def services(building_data, uvals, supplier_name = nil, remove_cafm_help = true)
      sum_uom = 0.0
      sum_benchmark = 0.0
      results = {}

      copy_params building_data, uvals

      # TODO : Validation must be put in the front end to NOT allow just CAFM or HELP services otherwise an exception be ge generated below in .max
      uvals_remove_cafm_help = if remove_cafm_help == true
                                 uvals.reject { |x| x[:service_code] == 'M.1' || x[:service_code] == 'N.1' }
                               else
                                 uvals
                               end
      uvals_remove_cafm_help.each do |v|
        uom_value = v[:uom_value]

        if v[:service_code] == 'G.3' || (v[:service_code] == 'G.1')
          occupants = v[:uom_value].to_i
          uom_value = (building_data[:gia] || building_data['gia']).to_f
        else
          occupants = 0
        end

        calc_fm = FMCalculator::Calculator.new(@contract_length_years,
                                               v[:service_code],
                                               v[:service_standard],
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
        sum_uom += calc_fm.sumunitofmeasure
        sum_benchmark += calc_fm.benchmarkedcostssum if supplier_name.nil?
        results[v[:service_code]] = calc_fm.results if supplier_name
      end
      return { sum_uom: sum_uom, results: results } if supplier_name

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

    def calculate_assessed_value
      return buyer_input if buyer_input != 0.0 && sum_uom == 0.0 && sum_benchmark == 0.0

      values = values_to_average

      values << buyer_input unless buyer_input.zero?
      (values.sum / values.size).to_f
    end

    def values_to_average
      if any_services_missing_framework_price?
        if any_services_missing_benchmark_price?
          return [] if variance_over_30_percent?((sum_uom + sum_benchmark) / 2, buyer_input) && !buyer_input.zero?
        elsif variance_over_30_percent?(sum_uom, (buyer_input + sum_benchmark) / 2)
          return [sum_benchmark]
        end
      end

      [sum_uom, sum_benchmark]
    end

    def any_services_missing_framework_price?
      frozen_rates = CCS::FM::FrozenRate.where(facilities_management_procurement_id: @procurement.id)
      rate_model = frozen_rates unless frozen_rates.size.zero?
      rate_model = CCS::FM::Rate if frozen_rates.size.zero?

      @procurement.procurement_building_services.any? { |pbs| rate_model.framework_rate_for(pbs.code, pbs.service_standard).nil? }
    end

    def any_services_missing_benchmark_price?
      frozen_rates = CCS::FM::FrozenRate.where(facilities_management_procurement_id: @procurement.id)
      rate_model = frozen_rates unless frozen_rates.size.zero?
      rate_model = CCS::FM::Rate if frozen_rates.size.zero?

      @procurement.procurement_building_services.any? { |pbs| rate_model.benchmark_rate_for(pbs.code, pbs.service_standard).nil? }
    end

    def variance_over_30_percent?(new, baseline)
      variance = (new - baseline) / baseline

      variance > 0.3 || variance < -0.3
    end
  end
end
