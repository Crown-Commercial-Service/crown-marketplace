require 'holidays'
require 'pg'

# rubocop:disable Metrics/ParameterLists (with a s)
# rubocop:disable Metrics/AbcSize

module FMCalculator
  class Calculator
    attr_writer :uom, :framework_rate

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
      read_benchmark_rates
    end

    def read_benchmark_rates
      con = PG.connect(dbname: 'marketplace_development', user: 'mike')
      rs = con.exec 'SELECT code, framework, benchmark FROM public.fm_rates;'
      @benchmark_rates = {}
      @framework_rates = {}
      rs.each do |row|
        @code = row['code'].remove('.')
        @framework = row['framework']
        @benchmark = row['benchmark']
        @benchmark_rates[@code] = @benchmark.to_f
        @framework_rates[@code] = @framework.to_f
      end
      rs&.clear if rs
      con&.close if con
    end

    def uomd
      @framework_rate = @framework_rates[@service_ref]

      # benchmark rate set here
      @benchmark_rate = @benchmark_rates[@service_ref]
      Rails.logger.info('UOMD')
      Rails.logger.info("framework_rate=#{@framework_rate}")
      Rails.logger.info("service_ref = #{@service_ref}")
      @uomd = @uom_vol * @framework_rate
      Rails.logger.info("uomd=#{@uomd}")
      @uomd = @uomd.round(0)
    end

    def clean

      @clean = @occupants * @framework_rates['M146']
      Rails.logger.info("clean=#{@clean}")
      @clean = @clean.round(0)
    end

    def subtotal1
      @subtotal1 = @uomd + @clean

      Rails.logger.info("subtotal1=#{@subtotal1}")
      @subtotal1 = @subtotal1.round(0)
    end

    def variance
      Rails.logger.info("london_flag=#{@london_flag}")
      if @london_flag == 'Y'
        @variance = @subtotal1 * @benchmark_rates['M144']
        Rails.logger.info("variance=#{@variance}")
        @variance = @variance.round(0)
      else
        0
      end
    end

    def subtotal2
      @subtotal2 = @subtotal1 + @variance
      Rails.logger.info("subtotal2=#{@subtotal2}")
      @subtotal2 = @subtotal2.round(0)
    end

    def cafm
      if @cafm_flag == 'Y'
        @cafm = @subtotal2 * @framework_rates['M136']
        Rails.logger.info("cafm=#{@cafm}")
        @cafm = @cafm.round(0)
      else
        0
      end
    end

    def helpdesk
      Rails.logger.info("@helpdesk_flag=#{@helpdesk_flag}")
      if @helpdesk_flag == 'Y'
        @helpdesk = @subtotal2 * @framework_rates['M138']
        Rails.logger.info("helpdesk=#{@helpdesk}")
        @helpdesk = @helpdesk.round(0)
      else
        0
      end
    end

    def subtotal3
      @subtotal3 = @subtotal2 + @cafm + @helpdesk
      Rails.logger.info("subtotal3=#{@subtotal3}")
      @subtotal3 = @subtotal3.round(0)
    end

    def mobilisation
      @mobilisation = @subtotal3 * @framework_rates['M5']
      Rails.logger.info("mobilisation=#{@mobilisation}")
      @mobilisation = @mobilisation.round(0)
    end

    def tupe
      if @tupe_flag == 'Y'
        @tupe = @subtotal3 * @framework_rates['M148']
        Rails.logger.info("type=#{@tupe}")
        @tupe = @tupe.round(0)
      else
        0
      end
    end

    def year1
      @year1 = @subtotal3 + @mobilisation + @tupe
      Rails.logger.info("year1=#{@year1}")
      @year1 = @year1.round(0)
    end

    def manage
      @manage = @year1 * @framework_rates['M140']
      Rails.logger.info("manage=#{@manage}")
      @manage = @manage.round(0)
    end

    def corporate
      @corporate = @year1 * @framework_rates['M141']
      Rails.logger.info("corporate=#{@corporate}")
      @corporate = @corporate.round(0)
    end

    def year1total
      @year1total = @year1 + @manage + @corporate
      Rails.logger.info("year1total=#{@year1total}")
      @year1total = @year1total.round(0)
    end

    def profit
      @profit = @year1 * @framework_rates['M142']
      Rails.logger.info("profit=#{@profit}")
      @profit = @profit.round(0)
    end

    def year1totalcharges
      @year1totalcharges = @year1total + @profit
      Rails.logger.info("year1totalcharges=#{@year1totalcharges}")
      @year1totalcharges = @year1totalcharges.round(0)
    end

    def subyearstotal
      @subyearstotal = 2 * (@year1totalcharges - (((@mobilisation + (@mobilisation * @framework_rates['M140']) + (@mobilisation * @framework_rates['M141'])) * (@framework_rates['M142'] + 1))))
      Rails.logger.info("subyear1totalcharges==#{@subyearstotal}")
      @subyearstotal = @subyearstotal.round(0)
    end

    def totalcharges
      @year1totalcharges += @subyearstotal
      Rails.logger.info("@year1totalcharges=#{@year1totalcharges}")
      @year1totalcharges = @year1totalcharges.round(0)
    end

    def benchmarkedcosts
      Rails.logger.info("@benchmark_rate=#{@benchmark_rate}")
      @benchmark_rate = @benchmark_rates[@service_ref]
      Rails.logger.info("@benchmark_rate=#{@benchmark_rate}")
      @benchmarkedcosts = @benchmark_rate * @uom_vol

      Rails.logger.info("@benchmarkedcosts=#{@benchmarkedcosts}")
      @benchmarkedcosts = @benchmarkedcosts.round(0)
    end

    def benchclean
      Rails.logger.info("@occupants=#{@occupants}")
      @benchclean = @occupants * @framework_rates['M146']
      Rails.logger.info("@benchclean=#{@benchclean}")
      @benchclean = @benchclean.round(0)
    end

    def benchsubtotal1
      @benchsubtotal1 = @benchmarkedcosts + @benchclean
      Rails.logger.info("@benchsubtotal1 =#{@benchsubtotal1}")
      @benchsubtotal1 = @benchsubtotal1.round(0)
    end

    def benchvariation
      Rails.logger.info("@london_flag=#{@london_flag}")
      if @london_flag == 'Y'
        @benchvariance = @benchsubtotal1 * @benchmark_rates['M144']
        Rails.logger.info("@benchvariance=#{@benchvariance}")
        @benchvariance = @benchvariance.round(0)
      else
        0
      end
    end

    def benchsubtotal2
      @benchsubtotal2 = @benchvariance + @benchsubtotal1
      Rails.logger.info("@benchsubtotal2=#{@benchsubtotal2}")
      @benchsubtotal2 = @benchsubtotal2.round(0)
    end

    def benchcafm
      if @cafm_flag == 'Y'
        @benchcafm = @framework_rates['M136'] * @benchsubtotal2
        Rails.logger.info("@benchcafm=#{@benchcafm}")
        @benchcafm = @benchcafm.round(0)
      else
        0
      end
    end

    def benchhelpdesk
      Rails.logger.info("@helpdesk_flag =#{@helpdesk_flag}")
      if @helpdesk_flag == 'Y'
        Rails.logger.info("@framework_rates['M138']=#{@framework_rates['M138']}")
        @benchhelpdesk = @benchsubtotal2 * @framework_rates['M138']
        Rails.logger.info("@benchhelpdesk =#{@benchhelpdesk}")
        @benchhelpdesk = @benchhelpdesk.round(0)
      else
        0
      end
    end

    def benchsubtotal3
      @benchsubtotal3 = @benchsubtotal2 + @benchcafm + @benchhelpdesk
      Rails.logger.info("@benchsubtotal3=#{@benchsubtotal3}")
      @benchsubtotal3 = @benchsubtotal3
    end

    def benchmobilisation
      @benchmobilisation = @benchsubtotal3 * @framework_rates['M5']
      Rails.logger.info("uom3_vol=#{@uom_vol}")
      @benchmobilisation = @benchmobilisation.round(0)
    end

    def benchtupe
      if @tupe_flag == 'Y'
        @benchtupe = @benchsubtotal3 * @framework_rates['M148']
        Rails.logger.info("@benchtupe=#{@benchtupe}")
        @benchtupe = @benchtupe.round(0)
      else
        0
      end
    end

    def benchyear1
      @benchyear1 = @benchsubtotal3 + @benchmobilisation + @benchtupe
      Rails.logger.info("@benchyear1=#{@benchyear1}")
      @benchyear1 = @benchyear1.round(0)
    end

    def benchmanage
      @benchmanage = @benchyear1 * @framework_rates['M140']
      Rails.logger.info("@benchmanage=#{@benchmanage}")
      @benchmanage = @benchmanage.round(0)
    end

    def benchcorporate
      @benchcorporate = @benchyear1 * @framework_rates['M141']
      Rails.logger.info("@benchyear1total=#{@benchcorporate}")
      @benchcorporate = @benchcorporate.round(0)
    end

    def benchyear1total
      @benchyear1total = @benchyear1 + @benchmanage + @benchcorporate
      Rails.logger.info("u@benchyear1total=#{@benchyear1total}")
      @benchyear1total = @benchyear1total.round(0)
    end

    def benchprofit
      @benchprofit = @benchyear1 * @framework_rates['M142']
      Rails.logger.info("u@benchprofit=#{@benchprofit}")
      @benchprofit = @benchprofit.round(0)
    end

    def benchyear1totalcharges
      @benchyear1totalcharges = @benchyear1total + @benchprofit
      Rails.logger.info("@benchyear1totalcharges=#{@benchyear1totalcharges}")
      @benchyear1totalcharges = @benchyear1totalcharges.round(0)
    end

    def benchsubyearstotal
      @benchsubyearstotal = 2 * (@benchyear1totalcharges - (((@benchmobilisation + (@benchmobilisation * @framework_rates['M140']) + (@benchmobilisation * @framework_rates['M141'])) * (@framework_rates['M142'] + 1))))
      Rails.logger.info("@benchsubyearstotal=#{@benchsubyearstotal}")
      @benchsubyearstotal = @benchsubyearstotal.round(0)
    end

    def benchtotalcharges
      @benchyear1totalcharges += @benchsubyearstotal

      Rails.logger.info(" @benchtotalcharges#{@benchtotalcharges}")
      @benchyear1totalcharges = @benchyear1totalcharges.round(0)
    end

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
