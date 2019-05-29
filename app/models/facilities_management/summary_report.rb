module FacilitiesManagement
  class SummaryReport
    attr_reader :sum_uom, :sum_benchmark, :building_data, :contract_length_years, :start_date, :tupe_flag

    def initialize(start_date, user_id, data)
      @start_date = start_date
      @user_id = user_id
      @data = data
      @posted_services = @data['posted_services']
      @posted_locations = @data['posted_locations']
      @contract_length_years = @data['fm-contract-length'].to_i
      @contract_cost = @data['fm-contract-cost'].to_f

      @tupe_flag =
        begin
          if @data['contract-tupe-radio'] == 'yes'
            'Y'
          else
            'N'
          end
        rescue StandardError
          'N'
        end

      @sum_uom = 0
      @sum_benchmark = 0
    end

    def calculate_services_for_buildings

      selected_services

      @sum_uom = 0
      @sum_benchmark = 0

      @building_data = CCS::FM::Building.buildings_for_user(@user_id)

      services = selected_services.sort_by(&:code)
      selected_services = services.collect(&:code)
      selected_services = selected_services.map { |s| s.gsub('.', '-') }
      selected_buildings = @building_data.select do |b|
        b_services = b.building_json['services'].collect { |s| s['code'] }
        (selected_services & b_services).any?
      end

      uvals = uom_values

      selected_buildings.each do |building|
        services building.building_json, uvals
      end
    end

    def with_pricing
      # CCS::FM::Rate.non_zero_rate
      services_with_pricing = CCS::FM::Rate.non_zero_rate.map(&:code)

      FacilitiesManagement::Service.all.select do |service|
        (@posted_services.include? service.code) && (services_with_pricing.include? service.code)
      end
    end

    def without_pricing
      # CCS::FM::Rate.zero_rate
      services_without_pricing = CCS::FM::Rate.zero_rate.map(&:code)

      FacilitiesManagement::Service.all.select do |service|
        (@posted_services.include? service.code) && (services_without_pricing.include? service.code)
      end
    end

    def selected_services
      @selected_services = FacilitiesManagement::Service.all.select { |service| @posted_services.include? service.code }
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

    def assessed_value
      return (@sum_uom + @sum_benchmark + @contract_cost) / 3 unless @contract_cost.zero?

      (@sum_uom + @sum_benchmark) / 2
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
      when 7000000..50000000
        'above £7 Million'
      else
        'above £50 Million'
      end
    end

    # take out
    def uom_values
      uvals = CCS::FM::UnitOfMeasurementValues.values_for_user(@user_id)
      uvals = uvals.map(&:attributes)

      lifts_per_building.each do | b |
        p b
        b['lift_data']['lift_data']['floor-data'].each do | l |
          p l
          uvals << { 'user_id' => b['user_id'], 'service_code' => 'C.5',  'uom_value' => l.first[1], 'building_id' => b['building_id'] }
        end
      end

      # add lift data to uvals

      uvals.reject! { |u| u['service_code'] == 'C.5' && u['uom_value'] == 'Saved' }
    end

    def lifts_per_building
      lifts_per_building = CCS::FM::Lift.lifts_for_user(@user_id)
      lifts_per_building.map(&:attributes)
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def copy_params(building_json)
      @fm_gross_internal_area =
        begin
          building_json['gia'].to_i
        rescue StandardError
          0
        end

      @london_flag =
        begin
          if building_json['isLondon'] == 'Yes'
            'Y'
          else
            'N'
          end
        rescue StandardError
          'N'
        end

      @cafm_flag =
        begin
          if building_json['services'].any? { |x| x['name'] == 'CAFM system' }
            'Y'
          else
            'N'
          end
        rescue StandardError
          'N'
        end

      @helpdesk_flag =
        begin
          if building_json['services'].any? { |x| x['name'] == 'Helpdesk services' }
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

    def occupants(code, building_json)
      case code
      when 'G.3'
        begin
          @uom_dict[building_json['id']][service.code]['uom_value'].to_i
        rescue StandardError
          0
        end
      else
        0
      end
    end

    def services(building_data, uvals)
      copy_params building_data
      id = building_data['id']

      with_pricing.each do |service|
        # puts service.code
        # puts service.name
        # puts service.mandatory
        # puts service.mandatory?
        # puts service.work_package
        # puts service.work_package.code
        # puts service.work_package.name
        #


        occupants = occupants(service.code, building_data)

        # next unless uvals[id]
        # next unless uvals[id].key? service.code

        uom_value = uvals.select { | u | u['service_code'] == service.code }.first['uom_value'] # uvals[id][service.code]['uom_value']

        uom_value = uom_value.to_f

        code = service.code.remove('.')
        calc_fm = FMCalculator::Calculator.new(@contract_length_years, code, uom_value, occupants, @tupe_flag, @london_flag, @cafm_flag, @helpdesk_flag)
        @sum_uom += calc_fm.sumunitofmeasure
        @sum_benchmark = calc_fm.benchmarkedcostssum



      end
    rescue StandardError => e
      raise e
    end
  end
end
