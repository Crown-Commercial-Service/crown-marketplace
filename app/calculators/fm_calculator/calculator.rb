require 'holidays'
require 'pg'

# rubocop:disable Metrics/ParameterLists (with a s)
# rubocop:disable Metrics/AbcSize
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

    @@benchmark_rates = nil
    @@framework_rates = nil

    def initialize(service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
      @service_ref = service_ref
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag
      @subtotal2 = 0
      @uomd = 0
      @clean = 0
      @variance = 0
      @subtotal1 = 0
      @cafm = 0
      @helpdesk = 0
      @mobilisation = 0
      @year1 = 0
      @manage = 0
      @year1total = 0
      @profit = 0
      @year1totalcharges = 0
      @benchmark_rate = 0
      @framework_rate = 0
      @benchmarkedcosts = 0
      @benchclean = 0
      @tupe = 0
      @benchcafm = 0
      @benchhelpdesk = 0
      @benchsubtotal2 = 0
      @benchsubtotal3 = 0
      @benchvariance = 0
      read_benchmark_rates if @@benchmark_rates.nil?
    end

    # read in the benchmark and framework rates - these were taken from the Damolas spreadsheet and put in the postgres database numbers are to 15dp
    def read_benchmark_rates
      query = 'SELECT code, framework, benchmark FROM fm_rates;'
      rs = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
      @@benchmark_rates = {}
      @@framework_rates = {}
      rs.each do |row|
        @code = row['code'].remove('.')
        framework = row['framework']
        benchmark = row['benchmark']
        @@benchmark_rates[@code] = benchmark.to_f
        @@framework_rates[@code] = framework.to_f
      end
    end

    # unit of measurable deliverables = framework_rate * unit of measure volume
    def uomd
      @framework_rate = @@framework_rates[@service_ref]

      # benchmark rate set here
      @benchmark_rate = @@benchmark_rates[@service_ref]

      @uomd = @uom_vol * @framework_rate

      @uomd = @uomd.round(0)
    rescue StandardError => e
      raise e
    end

    # cleaning consumables
    def clean
      @clean = @occupants * @@framework_rates['M146']

      @clean = @clean.round(0)
    end

    # subtotal1 = unit of measurable deliverables + cleaning consumables
    def subtotal1
      @subtotal1 = @uomd + @clean

      @subtotal1 = @subtotal1.round(0)
    end

    # London location variance based on being in london and a framework rate multiplied by subtotal1
    def variance
      if @london_flag == 'Y'
        @variance = @subtotal1 * @@benchmark_rates['M144']

        @variance = @variance.round(0)
      else
        0
      end
    end

    # subtotal2 = subtotal1 + variance
    def subtotal2
      @subtotal2 = @subtotal1 + @variance

      @subtotal2 = @subtotal2.round(0)
    end

    # if cafm flag is set then subtotal * framework rate
    def cafm
      if @cafm_flag == 'Y'
        @cafm = @subtotal2 * @@framework_rates['M136']

        @cafm = @cafm.round(0)
      else
        0
      end
    end

    # if helpdesk_flag is set then multiply by subtotal2
    def helpdesk
      if @helpdesk_flag == 'Y'
        @helpdesk = @subtotal2 * @@framework_rates['M138']

        @helpdesk = @helpdesk.round(0)
      else
        0
      end
    end

    # subtotal3 = subtotal2 + cafm + helpdesk
    def subtotal3
      @subtotal3 = @subtotal2 + @cafm + @helpdesk

      @subtotal3 = @subtotal3.round(0)
    end

    # mobilisation = subtotal3 * framework_rate
    def mobilisation
      @mobilisation = @subtotal3 * @@framework_rates['M5']

      @mobilisation = @mobilisation.round(0)
    end

    # if tupe_flag set then calculate tupe risk premium = subtotal3 * framework rate
    def tupe
      if @tupe_flag == 'Y'
        @tupe = @subtotal3 * @@framework_rates['M148']

        @tupe = @tupe.round(0)
      else
        0
      end
    end

    # total  year 1 deliverables value
    def year1
      @year1 = @subtotal3 + @mobilisation + @tupe

      @year1 = @year1.round(0)
    end

    # Management overhead
    def manage
      @manage = @year1 * @@framework_rates['M140']

      @manage = @manage.round(0)
    end

    # Corporate overhead
    def corporate
      @corporate = @year1 * @@framework_rates['M141']

      @corporate = @corporate.round(0)
    end

    # Year 1 total charges subtotal
    def year1total
      @year1total = @year1 + @manage + @corporate

      @year1total = @year1total.round(0)
    end

    # framework profit
    def profit
      @profit = @year1 * @@framework_rates['M142']
      @profit = @profit.round(0)
    end

    # year 1 total charges
    def year1totalcharges
      @year1totalcharges = @year1total + @profit

      @year1totalcharges = @year1totalcharges.round(0)
    end

    # subsequent year(s) total charges
    def subyearstotal
      @subyearstotal = 2 * (@year1totalcharges - (((@mobilisation + (@mobilisation * @@framework_rates['M140']) + (@mobilisation * @@framework_rates['M141'])) * (@@framework_rates['M142'] + 1))))

      @subyearstotal = @subyearstotal.round(0)
    end

    # total charges
    def totalcharges
      @year1totalcharges += @subyearstotal
      @year1totalcharges = @year1totalcharges.round(0)
    end

    # benchmarked costs start = benchmark rates * unit of mesasure volume
    def benchmarkedcosts
      benchmark_rate = @@benchmark_rates[@service_ref]
      benchmarkedcosts = benchmark_rate * @uom_vol

      @benchmarkedcosts = benchmarkedcosts.round(0)
    end

    # cleaning consumables using benchmark rate
    def benchclean
      @benchclean = @occupants * @@framework_rates['M146']
      @benchclean = @benchclean.round(0)
    end

    # benchmark subtotal1
    def benchsubtotal1
      @benchsubtotal1 = @benchmarkedcosts + @benchclean
      @benchsubtotal1 = @benchsubtotal1.round(0)
    end

    # benchmark variation if london_flag set
    def benchvariation
      if @london_flag == 'Y'
        @benchvariance = @benchsubtotal1 * @@benchmark_rates['M144']
        @benchvariance = @benchvariance.round(0)
      else
        0
      end
    end

    # benchmark subtotal2
    def benchsubtotal2
      @benchsubtotal2 = @benchvariance + @benchsubtotal1
      @benchsubtotal2 = @benchsubtotal2.round(0)
    end

    # benchmark cafm if flag set
    def benchcafm
      if @cafm_flag == 'Y'
        @benchcafm = @@framework_rates['M136'] * @benchsubtotal2
        @benchcafm = @benchcafm.round(0)
      else
        0
      end
    end

    # benchmark helpsdesk costs if helpdesk_flag set
    def benchhelpdesk
      if @helpdesk_flag == 'Y'
        @benchhelpdesk = @benchsubtotal2 * @@framework_rates['M138']
        @benchhelpdesk = @benchhelpdesk.round(0)
      else
        0
      end
    end

    # bench mark subtotal 3
    def benchsubtotal3
      @benchsubtotal3 = @benchsubtotal2 + @benchcafm + @benchhelpdesk
      @benchsubtotal3 = @benchsubtotal3
    end

    # benchmark mobilisation costs
    def benchmobilisation
      @benchmobilisation = @benchsubtotal3 * @@framework_rates['M5']
      @benchmobilisation = @benchmobilisation.round(0)
    end

    # benchmark tupe costs if flag set
    def benchtupe
      if @tupe_flag == 'Y'
        @benchtupe = @benchsubtotal3 * @@framework_rates['M148']
        @benchtupe = @benchtupe.round(0)
      else
        0
      end
    end

    # bench mark total year1 deliverables value
    def benchyear1
      @benchyear1 = @benchsubtotal3 + @benchmobilisation + @benchtupe
      @benchyear1 = @benchyear1.round(0)
    end

    # benchmark mananagement overhead costs
    def benchmanage
      @benchmanage = @benchyear1 * @@framework_rates['M140']
      @benchmanage = @benchmanage.round(0)
    end

    # bench mark corporate overhead cost
    def benchcorporate
      @benchcorporate = @benchyear1 * @@framework_rates['M141']
      @benchcorporate = @benchcorporate.round(0)
    end

    # total year 1 charges subtotal
    def benchyear1total
      @benchyear1total = @benchyear1 + @benchmanage + @benchcorporate
      @benchyear1total = @benchyear1total.round(0)
    end

    # bench mark profit
    def benchprofit
      @benchprofit = @benchyear1 * @@framework_rates['M142']

      @benchprofit = @benchprofit.round(0)
    end

    # bench mark year 1 total charges
    def benchyear1totalcharges
      @benchyear1totalcharges = @benchyear1total + @benchprofit
      @benchyear1totalcharges = @benchyear1totalcharges.round(0)
    end

    # bench mark subsequent year(s) total charges
    def benchsubyearstotal
      @benchsubyearstotal = 2 * (@benchyear1totalcharges - (((@benchmobilisation + (@benchmobilisation * @@framework_rates['M140']) + (@benchmobilisation * @@framework_rates['M141'])) * (@@framework_rates['M142'] + 1))))
      @benchsubyearstotal = @benchsubyearstotal.round(0)
    end

    # total bench mark charges
    def benchtotalcharges
      @benchyear1totalcharges += @benchsubyearstotal

      @benchyear1totalcharges = @benchyear1totalcharges.round(0)
    end

    # entry point to calculate sum of the unit of measure
    def sumunitofmeasure(service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
      @service_ref = service_ref
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag

      initialize(service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
      uomd
      clean
      subtotal1
      variance
      subtotal2
      cafm
      helpdesk
      subtotal3
      mobilisation
      tupe
      year1
      manage
      corporate
      year1total
      profit
      year1totalcharges
      subyearstotal
    end

    # entry point to calculate bench marked sum
    def benchmarkedcostssum(service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
      @service_ref = service_ref
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag
      initialize(service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
      benchmarkedcosts
      benchclean
      benchsubtotal1
      benchvariation
      benchsubtotal2
      benchcafm
      benchhelpdesk
      benchsubtotal3
      benchmobilisation
      benchtupe
      benchyear1
      benchmanage
      benchcorporate
      benchyear1total
      benchprofit
      benchyear1totalcharges
      benchsubyearstotal
    end
  end
end

# rubocop:enable Metrics/ParameterLists (with a s)
# rubocop:enable Metrics/AbcSize
