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
      @gia_services =
        ['C-1', 'C-10', 'C-11', 'C-12', 'C-13', 'C-14', 'C-15', 'C-16', 'C-17', 'C-18', 'C-2', 'C-20', 'C-3', 'C-4', 'C-6', 'C-7', 'C-8', 'C-9', 'D-1', 'D-2', 'D-4', 'D-5', 'D-6', 'E-1', 'E-2', 'E-3', 'E-5', 'E-6', 'E-7', 'E-8', 'F-1', 'G-1', 'G-10', 'G-11', 'G-14', 'G-15', 'G-16', 'G-2', 'G-3', 'G-4', 'G-6', 'G-7', 'G-9', 'H-1', 'H-10', 'H-11', 'H-13', 'H-2', 'H-3', 'H-6', 'H-7', 'H-8', 'H-9', 'J-10', 'J-11', 'J-7', 'J-9', 'L-2', 'L-3', 'L-4', 'L-5']
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

      uvals = uom_values(selected_buildings, selected_services)

      selected_buildings.each do |building|
        id = building['building_json']['id']
        services building.building_json, (uvals.select { |u| u['building_id'] == id })
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

    # rubocop:disable Metrics/AbcSize
    def uom_values(selected_buildings, selected_services)
      uvals = CCS::FM::UnitOfMeasurementValues.values_for_user(@user_id)
      uvals = uvals.map(&:attributes)

      # add labels for spreadsheet
      uvals.each do |u|
        uoms = CCS::FM::UnitsOfMeasurement.service_usage(u['service_code'])
        u['title_text'] = uoms.last['title_text']
        u['example_text'] = uoms.last['example_text']
      end

      # T.C.
      lift_service = uvals.select { |s| s['service_code'] == 'C.5'}
      lifts_title_text = lift_service.last['title_text']
      lifts_example_text = lift_service.last['title_text']

      uvals.reject! { |u| u['service_code'] == 'C.5' && u['uom_value'] == 'Saved' }

      lifts_per_building.each do |b|
        b['lift_data']['lift_data']['floor-data'].each do |l|
          uvals << { 'user_id' => b['user_id'],
                     'service_code' => 'C.5',
                     'uom_value' => l.first[1],
                     'building_id' => b['building_id'],
                     'title_text' => lifts_title_text,
                     'example_text' => lifts_example_text}
        end
      end

      selected_buildings.each do |b|
        selected_services.each do |s|
          next unless @gia_services.include? s

          s_dot = s.gsub('-', '.')
          uvals << { 'user_id' => b['user_id'],
                     'service_code' => s_dot,
                     'uom_value' => b['building_json']['gia'].to_f,
                     'building_id' => b['building_json']['id'],
                     'title_text' => 'What is the total internal area of this building?',
                     'example_text' => 'For example, 18000 sqm. When the gross internal area (GIA) measures 18,000 sqm' }
        end
      end

      uvals
    end
    # rubocop:enable Metrics/AbcSize

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

    def services(building_data, uvals)
      copy_params building_data
      # id = building_data['id']

      # with_pricing.each do |service|
      uvals.each do |v|
        # puts service.code
        # puts service.name
        # puts service.mandatory
        # puts service.mandatory?
        # puts service.work_package
        # puts service.work_package.code
        # puts service.work_package.name
        #

        # occupants = occupants(v['service_code'], building_data)
        occupants = v['uom_value'] if v['service_code'] == 'G.3' || (v['service_code'] == 'G.1')

        uom_value = v['uom_value'].to_f

        code = v['service_code'].remove('.')
        calc_fm = FMCalculator::Calculator.new(@contract_length_years, code, uom_value, occupants.to_i, @tupe_flag, @london_flag, @cafm_flag, @helpdesk_flag)
        @sum_uom += calc_fm.sumunitofmeasure
        @sum_benchmark = calc_fm.benchmarkedcostssum
      end
    rescue StandardError => e
      raise e
    end
  end
end
