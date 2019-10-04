require 'holidays'

#
# # facilities management calculator based on Damolas spreadsheet -  the first set framework calculations are repeated with a benchmark rate to give two values
# # 1. Unit of measure of deliverables required
#
# # 3. Benchmarked costs
# # the calculations are simple and sequential based on previous totals which are then used for subsequent calculations - calculations are either summing or multiplication
# # cafm = computer aided facilities management
# # tupe = transfer underlying protection of employment

module FMCalculator
  class Calculator
    attr_writer :uom, :framework_rate

    @benchmark_rates = nil
    @framework_rates = nil

    # rubocop:disable Metrics/ParameterLists (with a s)
    def initialize(contract_length_years, service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag,
                   rates, rate_card = nil, supplier_name = nil, building_data = nil)
      @contract_length_years = contract_length_years
      @subsequent_length_years = contract_length_years - 1
      @service_ref = service_ref
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag

      @benchmark_rates = rates[:benchmark_rates]
      @framework_rates = rates[:framework_rates]

      @supplier_name = supplier_name
      if supplier_name
        @rate_card_discounts = rate_card.data['Discounts'][@supplier_name]
        @rate_card_variances = rate_card.data['Variances'][@supplier_name]
        @rate_card_prices = rate_card.data['Prices'][@supplier_name]
      end

      @building_data = building_data
    end
    # rubocop:enable Metrics/ParameterLists (with a s)

    # unit of measurable deliverables = framework_rate * unit of measure volume
    def uomd
      @framework_rate = @framework_rates[@service_ref].to_f

      # benchmark rate set here
      # @benchmark_rate = @benchmark_rates[@service_ref].to_f

      if @supplier_name && @rate_card_discounts[@service_ref]
        (1 - @rate_card_discounts[@service_ref]['Disc %'].to_f) * @uom_vol * @rate_card_prices[@service_ref][@building_data[:fm_building_type]].to_f
      else
        @uom_vol * @framework_rates[@service_ref].to_f
      end
    rescue StandardError => e
      raise e
    end

    # cleaning consumables
    def clean
      @clean =
        if @supplier_name
          @occupants * @rate_card_variances['Cleaning Consumables per Building User (£)']
        else
          @occupants * @framework_rates['M146']
        end
    end

    # London location variance based on being in london and a framework rate multiplied by subtotal1
    def variance(subtotal1)
      if @london_flag == 'Y'
        if @supplier_name
          subtotal1 * rate_card_variances['London Location Variance Rate (%)'].to_f
        else
          subtotal1 * @benchmark_rates['M144'].to_f
        end
      else
        0
      end
    end

    # if cafm flag is set then subtotal * framework rate
    def cafm(subtotal2)
      if @cafm_flag == 'Y'
        if @supplier_name
          subtotal2 * @rate_card_prices['M.1'][@building_data[:fm_building_type]].to_f
        else
          subtotal2 * @framework_rates['M136']
        end
      else
        0
      end
    end

    # if helpdesk_flag is set then multiply by subtotal2
    def helpdesk(subtotal2)
      if @helpdesk_flag == 'Y'
        if @supplier_name
          subtotal2 * @rate_card_prices['M.1'][@building_data[:fm_building_type]].to_f
        else
          subtotal2 * @framework_rates['M138']
        end
      else
        0
      end
    end

    # mobilisation = subtotal3 * framework_rate
    def mobilisation(subtotal3)
      if @supplier_name
        subtotal3 * @rate_card_variances['Mobilisation Cost (DA %)'].to_f
      else
        subtotal3 * @framework_rates['M5']
      end
    end

    # if tupe_flag set then calculate tupe risk premium = subtotal3 * framework rate
    def tupe(subtotal3)
      if @tupe_flag == 'Y'
        if @supplier_name
          subtotal3 * @rate_card_variances['TUPE Risk Premium (DA %)'].to_f
        else
          subtotal3 * @framework_rates['M148']
        end
      else
        0
      end
    end

    # Management overhead
    def manage(year1)
      if @supplier_name
        year1 * @rate_card_variances['Management Overhead %']
      else
        year1 * @framework_rates['M140']
      end
    end

    # Corporate overhead
    def corporate(year1)
      if @supplier_name
        year1 * @rate_card_variances['Corporate Overhead %']
      else
        year1 * @framework_rates['M141']
      end
    end

    # framework profit
    def profit(year1)
      if @supplier_name
        year1 * @rate_card_variances['Profit %']
      else
        year1 * @framework_rates['M142']
      end
    end

    # subsequent year(s) total charges
    def subyearstotal(year1totalcharges, mobilisation)
      if @supplier_name
        @subsequent_length_years *
          (year1totalcharges -
            (((mobilisation + (mobilisation * @rate_card_variances['Management Overhead %']) +
              (mobilisation * @rate_card_variances['Corporate Overhead %'])) *
                (@rate_card_variances['Profit %'] + 1))))
      else
        @subsequent_length_years * (year1totalcharges - (((mobilisation + (mobilisation * @framework_rates['M140']) + (mobilisation * @framework_rates['M141'])) * (@framework_rates['M142'] + 1))))
      end
    end

    # benchmarked costs start = benchmark rates * unit of mesasure volume
    def benchmarkedcosts
      benchmark_rate = @benchmark_rates[@service_ref].to_f
      benchmark_rate * @uom_vol
    end

    # cleaning consumables using benchmark rate
    def benchclean
      @benchclean = @occupants * @framework_rates['M146']
    end

    # benchmark variation if london_flag set
    def benchvariation(benchsubtotal1)
      if @london_flag == 'Y'
        @benchvariance = benchsubtotal1 * @benchmark_rates['M144'].to_f
      else
        0
      end
    end

    # benchmark cafm if flag set
    def benchcafm(benchsubtotal2)
      if @cafm_flag == 'Y'
        @framework_rates['M136'] * benchsubtotal2
      else
        0
      end
    end

    # benchmark helpsdesk costs if helpdesk_flag set
    def benchhelpdesk(benchsubtotal2)
      if @helpdesk_flag == 'Y'
        @benchhelpdesk = benchsubtotal2 * @framework_rates['M138']
      else
        0
      end
    end

    # benchmark mobilisation costs
    def benchmobilisation(benchsubtotal3)
      benchsubtotal3 * @framework_rates['M5']
    end

    # benchmark tupe costs if flag set
    def benchtupe(benchsubtotal3)
      if @tupe_flag == 'Y'
        benchsubtotal3 * @framework_rates['M148']
      else
        0
      end
    end

    # benchmark mananagement overhead costs
    def benchmanage(benchyear1)
      benchyear1 * @framework_rates['M140']
    end

    # bench mark corporate overhead cost
    def benchcorporate(benchyear1)
      benchyear1 * @framework_rates['M141']
    end

    # bench mark profit
    def benchprofit(benchyear1)
      benchyear1 * @framework_rates['M142']
    end

    # bench mark subsequent year(s) total charges
    def benchsubyearstotal(benchyear1totalcharges, benchmobilisation)
      @subsequent_length_years * (benchyear1totalcharges - (((benchmobilisation + (benchmobilisation * @framework_rates['M140']) + (benchmobilisation * @framework_rates['M141'])) * (@framework_rates['M142'] + 1))))
    end

    # entry point to calculate sum of the unit of measure
    def sumunitofmeasure
      subtotal1 = uomd + clean
      subtotal2 = subtotal1 + variance(subtotal1)
      subtotal3 = subtotal2 + cafm(subtotal2) + helpdesk(subtotal2)
      mobilisation = mobilisation(subtotal3)
      year1 = subtotal3 + mobilisation + tupe(subtotal3)
      year1total = year1 + manage(year1) + corporate(year1)
      year1totalcharges = year1total + profit(year1)
      year1totalcharges + subyearstotal(year1totalcharges, mobilisation)
    end

    # entry point to calculate bench marked sum
    def benchmarkedcostssum
      benchsubtotal1 = benchmarkedcosts + benchclean
      benchsubtotal2 = benchsubtotal1 + benchvariation(benchsubtotal1)
      benchsubtotal3 = benchsubtotal2 + benchcafm(benchsubtotal2) + benchhelpdesk(benchsubtotal2)
      bench_mobilisation = benchmobilisation(benchsubtotal3)
      benchyear1 = benchsubtotal3 + bench_mobilisation + benchtupe(benchsubtotal3)
      benchyear1total = benchyear1 + benchmanage(benchyear1) + benchcorporate(benchyear1)

      benchyear1totalcharges = benchyear1total + benchprofit(benchyear1)
      benchyear1totalcharges + benchsubyearstotal(benchyear1totalcharges, bench_mobilisation)
    end
  end
end
