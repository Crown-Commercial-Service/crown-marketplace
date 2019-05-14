module FacilitiesManagement
  class SummaryReport
    attr_reader :sum_uom, :sum_benchmark

    def initialize(start_date, user_id, data)
      @start_date = start_date
      @user_id = user_id
      @data = data
      @posted_services = @data['posted_services']
      @posted_locations = @data['posted_locations']
      @contract_length_years = @data['fm-contract-length'].to_i

      @tupe_flag =
        if @data['contract-tupe-radio'] == 'yes'
          'Y'
        else
          'N'
        end

      @sum_uom = 0
      @sum_benchmark = 0
    end

    def calculate_services_for_buildings
      uom_values

      selected_services

      @sum_uom = 0
      @sum_benchmark = 0

      CCS::FM::Building.buildings_for_user(@user_id).each do |building|
        services building
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

    def assessed_value
      @sum_uom + @sum_benchmark
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

    private

    def uom_values
      @uom_dict = {}

      fm_service_data = FMServiceData.new

      uom_values = fm_service_data.uom_values(@user_id)
      uom_values.each do |values|
        values['description'] = fm_service_data.work_package_description(values['service_code'])
        values['unit_text'] = fm_service_data.work_package_unit_text(values['service_code'])
        @uom_dict[values['building_id']] ||= {}
        @uom_dict[values['building_id']][values['service_code']] = values
      end
      @lift_data = fm_service_data.get_lift_data(@user_id)
      @uom_dict
    end

    def copy_params(building_json)
      @fm_gross_internal_area = building_json['gia'].to_i

      @london_flag =
        if building_json['isLondon'] == 'Yes'
          'Y'
        else
          'N'
        end

      @cafm_flag =
        if building_json['services'].any? { |x| x['name'] == 'CAFM system' }
          'Y'
        else
          'N'
        end

      @helpdesk_flag =
        if building_json['services'].any? { |x| x['name'] == 'Helpdesk services' }
          'Y'
        else
          'N'
        end
    end

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

    def services(building)
      data = building.building_json
      copy_params data
      @selected_services.each do |service|
        # puts service.code
        # puts service.name
        # puts service.mandatory
        # puts service.mandatory?
        # puts service.work_package
        # puts service.work_package.code
        # puts service.work_package.name

        occupants = occupants(service.code, data)

        code = service.code.remove('.')
        calc_fm = FMCalculator::Calculator.new(@contract_length_years, code, @fm_gross_internal_area, occupants, @tupe_flag, @london_flag, @cafm_flag, @helpdesk_flag)
        @sum_uom += calc_fm.sumunitofmeasure(@contract_length_years, code, @fm_gross_internal_area, occupants, @tupe_flag, @london_flag, @cafm_flag, @helpdesk_flag)
        @sum_benchmark = calc_fm.benchmarkedcostssum(@contract_length_years, code, @fm_gross_internal_area, occupants, @tupe_flag, @london_flag, @cafm_flag, @helpdesk_flag)
      end
    rescue StandardError => e
      raise e
    end
  end
end
