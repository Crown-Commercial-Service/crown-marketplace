module FacilitiesManagement
  class SummaryReport
    attr_reader :sum_uom, :sum_benchmark
    attr_reader :building_data

    def initialize(start_date, user_id, data)
      @start_date = start_date
      @user_id = user_id
      @data = data
      @posted_services = @data[:posted_services]
      @posted_locations = @data[:posted_locations]

      @sum_uom = 0
      @sum_benchmark = 0
    end

    def calculate_services_for_buildings
      services_for_buildings
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

    private

    def services_for_buildings
      @sum_uom = 0
      @sum_benchmark = 0

      selected_services

      @building_data = CCS::FM::Building.buildings_for_user(@user_id)
      @building_data.each do |building|
        fm_gross_internal_area = building.building_json['fm-gross-internal-area'].to_i
        occupants = 125 # fix it !!!
        london_flag = if building.building_json['isLondon'] == 'Yes'
                        'Y'
                      else
                        'N'
                      end

        tupe_flag = 'Y' # fix it !!!
        cafm_flag = 'Y' # fix it !!!
        helpdesk_flag = 'N' # fix it !!!

        @selected_services.each do |service|
          # puts service.code
          # puts service.name
          # puts service.mandatory
          # puts service.mandatory?
          # puts service.work_package
          # puts service.work_package.code
          # puts service.work_package.name

          code = service.code.remove('.')
          calc_fm = FMCalculator::Calculator.new(code, fm_gross_internal_area, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
          uom_cost = calc_fm.sumunitofmeasure(code, fm_gross_internal_area, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
          benchmark_cost = calc_fm.benchmarkedcostssum(code, fm_gross_internal_area, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)

          @sum_uom += uom_cost
          @sum_benchmark += benchmark_cost
        end
      end
    end
  end
end
