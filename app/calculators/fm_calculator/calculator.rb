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
    attr_accessor :results

    @benchmark_rates = nil
    @framework_rates = nil

    # rubocop:disable Metrics/ParameterLists (with a s)
    def initialize(contract_length_years, service_ref, service_standard, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag, rates, rate_card, supplier_name = nil, building = nil)
      @contract_length_years = contract_length_years
      @subsequent_length_years = contract_length_years - 1
      @service_ref = service_ref
      @service_standard = service_standard
      @service_ref_sym = service_ref.to_sym
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag

      @benchmark_rates = rates[:benchmark_rates]
      @framework_rates = rates[:framework_rates]

      if supplier_name
        @supplier_name = supplier_name.to_sym
        @rate_card_discounts = rate_card.data[:Discounts][@supplier_name]
        @rate_card_variances = rate_card.data[:Variances][@supplier_name]
        @rate_card_prices = rate_card.data[:Prices][@supplier_name]
      end

      @building_type = building.building_type.to_sym if building
      @results = {}
    end
    # rubocop:enable Metrics/ParameterLists (with a s)

    # unit of measurable deliverables = framework_rate * unit of measure volume
    def uomd
      if @supplier_name && @rate_card_discounts[@service_ref_sym]
        (1 - @rate_card_discounts[@service_ref_sym][:'Disc %'].to_f) * @uom_vol * @rate_card_prices[@service_ref_sym][@building_type].to_f
      else
        @uom_vol * framework_rate_for(@service_ref.gsub('.', '')).to_f
      end
    rescue StandardError => e
      raise e
    end

    # cleaning consumables
    def clean
      @clean =
        if @supplier_name
          @occupants * @rate_card_variances[:'Cleaning Consumables per Building User (£)']
        else
          @occupants * framework_rate_for('M146')
        end
    end

    # London location variance based on being in london and a framework rate multiplied by subtotal2
    def variance(subtotal2)
      @variance ||= if @london_flag
                      if @supplier_name
                        subtotal2 * @rate_card_variances[:'London Location Variance Rate (%)'].to_f
                      else
                        subtotal2 * @framework_rates['M144'].to_f
                      end
                    else
                      0
                    end
    end

    # if cafm flag is set then subtotal * framework rate
    def cafm(subtotal1)
      @cafm ||= if @cafm_flag
                  if @supplier_name
                    subtotal1 * @rate_card_prices[:'M.1'][@building_type].to_f
                  else
                    subtotal1 * @framework_rates['M136']
                  end
                else
                  0
                end
    end

    # if helpdesk_flag is set then multiply by subtotal2
    def helpdesk(subtotal1)
      @helpdesk ||= if @helpdesk_flag
                      if @supplier_name
                        subtotal1 * @rate_card_prices[:'N.1'][@building_type].to_f
                      else
                        subtotal1 * @framework_rates['N138']
                      end
                    else
                      0
                    end
    end

    # mobilisation = subtotal3 * framework_rate
    def mobilisation(subtotal3)
      if @supplier_name
        subtotal3 * @rate_card_variances[:'Mobilisation Cost (DA %)'].to_f
      else
        subtotal3 * @framework_rates['B1']
      end
    end

    # if tupe_flag set then calculate tupe risk premium = subtotal3 * framework rate
    def tupe(subtotal3)
      # note: @tube_flag is now; true or false, not "Y" or "N"
      @tupe ||= if @tupe_flag
                  if @supplier_name
                    subtotal3 * @rate_card_variances[:'TUPE Risk Premium (DA %)'].to_f
                  else
                    subtotal3 * @framework_rates['M148']
                  end
                else
                  0
                end
    end

    # Management overhead
    def manage(year1)
      @manage ||= if @supplier_name
                    year1 * @rate_card_variances[:'Management Overhead %']
                  else
                    year1 * @framework_rates['M140']
                  end
    end

    # Corporate overhead
    def corporate(year1)
      @corporate ||= if @supplier_name
                       year1 * @rate_card_variances[:'Corporate Overhead %']
                     else
                       year1 * @framework_rates['M141']
                     end
    end

    # framework profit
    def profit(year1total)
      @profit ||= if @supplier_name
                    year1total * @rate_card_variances[:'Profit %']
                  else
                    year1total * @framework_rates['M142']
                  end
    end

    # subsequent year(s) total charges
    def subyearstotal(year1totalcharges, mobilisation)
      @subyearstotal ||= if @supplier_name
                           @subsequent_length_years *
                             (year1totalcharges -
                               (((mobilisation + (mobilisation * @rate_card_variances[:'Management Overhead %']) +
                                 (mobilisation * @rate_card_variances[:'Corporate Overhead %'])) *
                                 (@rate_card_variances[:'Profit %'] + 1))))
                         else
                           @subsequent_length_years * (year1totalcharges - (((mobilisation + (mobilisation * @framework_rates['M140']) + (mobilisation * @framework_rates['M141'])) * (@framework_rates['M142'] + 1))))
                         end
    end

    # benchmarked costs start = benchmark rates * unit of mesasure volume
    def benchmarkedcosts
      benchmark_rate = benchmark_rate_for(@service_ref.gsub('.', '')).to_f
      benchmark_rate * @uom_vol
    end

    # cleaning consumables using benchmark rate
    def benchclean
      @benchclean = @occupants * @benchmark_rates['M146']
    end

    # benchmark variation if london_flag set
    def benchvariation(benchsubtotal2)
      if @london_flag
        @benchvariance = benchsubtotal2 * @benchmark_rates['M144'].to_f
      else
        0
      end
    end

    # benchmark cafm if flag set
    def benchcafm(benchsubtotal1)
      if @cafm_flag
        @benchmark_rates['M136'] * benchsubtotal1
      else
        0
      end
    end

    # benchmark helpsdesk costs if helpdesk_flag set
    def benchhelpdesk(benchsubtotal1)
      if @helpdesk_flag
        @benchhelpdesk = benchsubtotal1 * @benchmark_rates['N138']
      else
        0
      end
    end

    # benchmark mobilisation costs
    def benchmobilisation(benchsubtotal3)
      benchsubtotal3 * @benchmark_rates['B1']
    end

    # benchmark tupe costs if flag set
    def benchtupe(benchsubtotal3)
      if @tupe_flag
        benchsubtotal3 * @benchmark_rates['M148']
      else
        0
      end
    end

    # benchmark mananagement overhead costs
    def benchmanage(benchyear1)
      benchyear1 * @benchmark_rates['M140']
    end

    # bench mark corporate overhead cost
    def benchcorporate(benchyear1)
      benchyear1 * @benchmark_rates['M141']
    end

    # bench mark profit
    def benchprofit(benchyear1)
      benchyear1 * @benchmark_rates['M142']
    end

    # bench mark subsequent year(s) total charges
    def benchsubyearstotal(benchyear1totalcharges, benchmobilisation)
      @subsequent_length_years * (benchyear1totalcharges - (((benchmobilisation + (benchmobilisation * @benchmark_rates['M140']) + (benchmobilisation * @benchmark_rates['M141'])) * (@benchmark_rates['M142'] + 1))))
    end

    # entry point to calculate sum of the unit of measure
    # rubocop:disable Metrics/AbcSize
    def sumunitofmeasure
      subtotal1 = uomd + clean
      subtotal2 = subtotal1 + cafm(subtotal1) + helpdesk(subtotal1)
      subtotal3 = subtotal2 + variance(subtotal2)
      mobilisation = mobilisation(subtotal3)
      year1 = subtotal3 + mobilisation

      year1total = year1 + manage(year1) + tupe(subtotal3) + corporate(year1 + tupe(subtotal3))
      year1totalcharges = year1total + profit(year1total)

      results[:subtotal1] = subtotal1
      results[:year1totalcharges] = year1totalcharges
      results[:cafm] = cafm(subtotal1)
      results[:helpdesk] = helpdesk(subtotal1)
      results[:variance] = variance(subtotal2)
      results[:tupe] = tupe(subtotal3)
      results[:manage] = manage(year1)
      results[:corporate] = corporate(year1 + results[:tupe])
      results[:profit] = profit(year1total)
      results[:mobilisation] = mobilisation
      results[:subyearstotal] = 0 # in all cases
      results[:subyearstotal] = (subyearstotal(year1totalcharges, mobilisation) / @subsequent_length_years) if @subsequent_length_years.positive?
      results[:contract_length_years] = @contract_length_years
      results[:subsequent_length_years] = @subsequent_length_years

      year1totalcharges + subyearstotal(year1totalcharges, mobilisation)
    end
    # rubocop:enable Metrics/AbcSize

    # entry point to calculate bench marked sum
    def benchmarkedcostssum
      benchsubtotal1 = benchmarkedcosts + benchclean
      benchsubtotal2 = benchsubtotal1 + benchcafm(benchsubtotal1) + benchhelpdesk(benchsubtotal1)
      benchsubtotal3 = benchsubtotal2 + benchvariation(benchsubtotal2)
      bench_mobilisation = benchmobilisation(benchsubtotal3)
      benchyear1 = benchsubtotal3 + bench_mobilisation + benchtupe(benchsubtotal3)
      benchyear1total = benchyear1 + benchmanage(benchyear1) + benchcorporate(benchyear1)

      benchyear1totalcharges = benchyear1total + benchprofit(benchyear1)
      benchyear1totalcharges + benchsubyearstotal(benchyear1totalcharges, bench_mobilisation)
    end

    protected

    def framework_rate_for(service_ref)
      @framework_rates[service_ref] || @framework_rates["#{service_ref}-#{@service_standard}"]
    end

    def benchmark_rate_for(service_ref)
      @benchmark_rates[service_ref] || @benchmark_rates["#{service_ref}-#{@service_standard}"]
    end
  end
end
