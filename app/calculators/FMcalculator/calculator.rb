require 'holidays'

module FMCalculator
  class Calculator
    attr_writer :uom, :framework_rate
# args  Service ref, uom_vol, occupants, tuoe, london_location, CAFM, helpdesk
    def initialize(service_ref,uom_vol,occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag )
      @service_ref = service_ref
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag
      @subtotal2=0
      @uomd = 0
      @clean=0
      @variance=0
      @subtotal1=0
      @cafm=0
      @helpdesk=0
      @mobilisation=0
      @year1=0
      @manage=0
      @year1total=0
      @profit=0
      @year1totalcharges=0
      @benchmark_rate=0
      @framework_rate=0
      @benchmarkedcosts=0
      @benchclean=0
      @tupe=0
      @benchcafm = 0
      @benchhelpdesk = 0
      @benchsubtotal2 =0
      @benchsubtotal3 =0
      @benchmark_rates = {"G1" => 5.18019173184857, "C5"=>210.4171460213030, "C19"=>0,"E4"=>0.803961762752,"K1"=>94.868311111111,"H4"=>19.9772030755081,"G5"=>2.62821655830568,"K2"=>225.674344919229,"K7"=> 23.5797540994624,"K144" => 0.18811284091,"M144" => 0.18811284090909100}
      @framework_rates =

          {"C19" => 0.0,"C5" => 210.4171460213030,"E4" => 0.803961762751901, "K1" =>94.8683111111111, "H4" =>19.9772030755081, "G5" => 2.62821655830568,"K2" =>225.674344919229, "K7" => 23.5797540994624, "G1"=>  12.0648071175937, "M5" => 0.065, "M136" => 0.0145394024,"M138" =>0.0298538068, "M140" => 0.10090441335,"M141"=>0.049824514991, "M142" =>0.05427986510,"M144" => 0.18811284090909100,  "M146" => 26.2091316010091000, "M148" =>0.103837037037037 }
      @benchmark2_rate = {}
    end

    # --- column o
    def uomd()
      @framework_rate = @framework_rates[@service_ref]
      # benchmark rate set here
      @benchmark_rate = @benchmark_rates[@service_ref]
      puts "framewwork_rate"
      puts @framework_rate
      puts @service_ref
      @uomd = @uom_vol * @framework_rate
      puts "uomd"
      puts @uomd
      @uomd = @uomd.round(0)
    end

    # --- column p
    def clean()
      @clean =  @occupants * @framework_rates['M146']
      puts "clean"
      puts @clean
      @clean = @clean.round(0)
    end

    # -- column  q
    def subtotal1()
      @subtotal1 = @uomd + @clean
      puts "subtotal1"
      puts @subtotal1
      @subtotal1 = @subtotal1.round(0)
    end

    # ---column r
    def variance()
      puts "london_flag"
      puts @london_flag
      if @london_flag == "Y"
        @variance = @subtotal1 * @benchmark_rates['M144']
        puts "variance"
        puts @variance
        @variance = @variance.round(0)
      else
        0
      end
    end



    # -- column s
    def subtotal2()
      @subtotal2 = @subtotal1 + @variance
      puts "subtotal2"
      puts @subtotal2
      @subtotal2 = @subtotal2.round(0)
    end

     # --- column t
    def cafm()
      if @cafm_flag == "Y"
        @cafm =  @subtotal2 * @framework_rates['M136']
        puts "cafm"
        puts @cafm
        @cafm = @cafm.round(0)
      else
        0
      end
    end

    def helpdesk()
      puts "helpdesk_flag"
      puts @helpdesk_flag
      if @helpdesk_flag == "Y"
        @helpdesk =  @subtotal2 * @framework_rates['M138']
        puts "helpdesk"
        puts @helpdesk
        @helpdesk = @helpdesk.round(0)
      else
        0
      end
      end

      def subtotal3()
        @subtotal3 = @subtotal2 + @cafm + @helpdesk
        puts "subtotal3"
        puts @subtotal3
        @subtotal3 = @subtotal3.round(0)
      end

      def mobilisation()
       @mobilisation = @subtotal3 * @framework_rates['M5']
       puts "mobilisationm"
       puts @mobilisation
       @mobilisation = @mobilisation.round(0)
      end

      def tupe()
        if @tupe_flag == "Y"
          @tupe =  @subtotal3 * @framework_rates['M148']
          puts "tupe"
          puts @tupe
          @tupe = @tupe.round(0)
        else
          0
        end
      end

      def year1()
        @year1 = @subtotal3 + @mobilisation + @tupe
        puts "year1"
        puts @year1
        @year1 = @year1.round(0)
      end

      def manage()
        @manage = @year1 * @framework_rates['M140']
        puts "manage"
        puts @manage
        @manage= @manage.round(0)
      end

      def corporate()
        @corporate = @year1 * @framework_rates['M141']
        puts "corporate"
        puts @corporate
        @corporate= @corporate.round(0)
      end

      def year1total()
        @year1total = @year1 + @manage + @corporate
        puts "year1total"
        puts @year1total
        @year1total = @year1total.round(0)
      end

      def profit()
        @profit = @year1 * @framework_rates['M142']
        puts "profit"
        puts @profit
        @profit= @profit.round(0)
      end

      def year1totalcharges()
        @year1totalcharges = @year1total + @profit
        puts "year1totalcharges"
        puts @year1totalcharges
        @year1totalcharges = @year1totalcharges.round(0)
      end

      def subyearstotal()
        @subyearstotal=2*(@year1totalcharges-(((@mobilisation+(@mobilisation*@framework_rates['M140']) + (@mobilisation*@framework_rates['M141'])) *(@framework_rates['M142']+1))))
        @subyearstotal = @subyearstotal.round(0)
      end

      def totalcharges()
        @year1totalcharges = @year1totalcharges + @subyearstotal
        @year1totalcharges = @year1totalcharges.round(0)
      end

      # --------------------------------- Benchmark

      def benchmarkedcosts()
        puts "uom3_vol"
        puts @uom_vol
        puts @benchmark_rate
        puts @uoml_vol
        puts "service_ref"
        puts @service_ref
        @benchmark_rate = @benchmark_rates[@service_ref]
        puts "benchmark_RATE"
        puts @benchmark_rate
        @benchmarkedcosts = @benchmark_rate * @uom_vol

        puts 'benchmarkedcosts'
        puts @benchmarkedcosts
        @benchmarkedcosts = @benchmarkedcosts.round(0)
      end

      def benchclean()
        puts "occupants"
        puts @occupants

        @benchclean =  @occupants * @framework_rates['M146']
        puts "benchclean"
        puts @benchclean
        @benchclean = @benchclean.round(0)

      end

      def benchsubtotal1()
        @benchsubtotal1  = @benchmarkedcosts + @benchclean
        puts "benchsubtotal1"
        puts @benchsubtotal1
        @benchsubtotal1 = @benchsubtotal1.round(0)
      end

      def benchvariation()
        puts "london_flag"
        puts @london_flag
        if @london_flag == "Y"
          @benchvariance = @benchsubtotal1 * @benchmark_rates['M144']
          puts "variance"
          puts @benchvariance
          @benchvariance = @benchvariance.round(0)
        else
          0
        end
      end

      def benchsubtotal2()
        @benchsubtotal2 = @benchvariance + @benchsubtotal1
        puts "benchsubtotal2"
        puts @benchsubtotal2
        @benchsubtotal2 = @benchsubtotal2.round(0)
      end

      def benchcafm()
        if @cafm_flag == "Y"
          @benchcafm =  @framework_rates['M136'] * @benchsubtotal2
          puts "benchcafm"
          puts @benchcafm
          @benchcafm = @benchcafm.round(0)
        else
          0
        end
      end

      def benchhelpdesk()
        puts "helpdesk_flag"
        puts @helpdesk_flag
        if @helpdesk_flag == "Y"
          puts "framework_rates['M138']"
          puts @framework_rates['M138']
          @benchhelpdesk = @benchsubtotal2 * @framework_rates['M138']
          puts "benchhelpdesk"
          puts @benchhelpdesk
          @benchhelpdesk = @benchhelpdesk.round(0)
        else
          0
        end
      end

      def benchsubtotal3()
        @benchsubtotal3 = @benchsubtotal2 + @benchcafm + @benchhelpdesk
        puts "benchsubtotal3"
        puts @benchsubtotal3
        @benchsubtotal3 = @benchsubtotal3
      end

      def benchmobilisation()
        @benchmobilisation = @benchsubtotal3 * @framework_rates['M5']
        puts "benchmobilisation"
        puts @benchmobilisation
        @benchmobilisation = @benchmobilisation.round(0)
       end
 
       def benchtupe()
         if @tupe_flag == "Y"
           @benchtupe =  @benchsubtotal3 * @framework_rates['M148']
           puts "benchtupe"
           puts @benchtupe
           @benchtupe = @benchtupe.round(0)
         else
           0
         end
       end
 
       def benchyear1()
         @benchyear1 = @benchsubtotal3 + @benchmobilisation + @benchtupe
         puts "benchyear1"
         puts @benchyear1
         @benchyear1 = @benchyear1.round(0)
       end
 
       def benchmanage()
         @benchmanage = @benchyear1 * @framework_rates['M140']
         puts "benchmanage"
         puts @benchmanage
         @benchmanage= @benchmanage.round(0)
       end
 
       def benchcorporate()
         @benchcorporate = @benchyear1 * @framework_rates['M141']
         puts "benchcorporate"
         puts @benchcorporate
         @benchcorporate= @benchcorporate.round(0)
       end
 
       def benchyear1total()
         @benchyear1total = @benchyear1 + @benchmanage + @benchcorporate
         puts "benchyear1total"
         puts @benchyear1total
         @benchyear1total = @benchyear1total.round(0)
       end
 
       def benchprofit()
         @benchprofit = @benchyear1 * @framework_rates['M142']
         puts "benchprofit"
         puts @benchprofit
         @benchprofit= @benchprofit.round(0)
       end
 
       def benchyear1totalcharges()
         @benchyear1totalcharges = @benchyear1total + @benchprofit
         puts "benchyear1totalcharges"
         puts @benchyear1totalcharges
         @benchyear1totalcharges = @benchyear1totalcharges.round(0)
       end
 
       def benchsubyearstotal()
         @benchsubyearstotal=2*(@benchyear1totalcharges-(((@benchmobilisation+(@benchmobilisation*@framework_rates['M140']) + (@benchmobilisation*@framework_rates['M141'])) *(@framework_rates['M142']+1))))
         puts "benchsubyearstotal"
         puts @benchsubyearstotal
         @benchsubyearstotal = @benchsubyearstotal.round(0)
       end
 
       def benchtotalcharges()
         @benchyear1totalcharges = @benchyear1totalcharges + @benchsubyearstotal
         puts "benchtotalcharges"
         puts @benchtotalcharges
         @benchyear1totalcharges = @benchyear1totalcharges.round(0)
       end
       
       def sumunitofmeasure(service_ref,uom_vol,occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag )
         @service_ref = service_ref
         @uom_vol = uom_vol
         @occupants = occupants
         @tupe_flag = tupe_flag
         @london_flag = london_flag
         @cafm_flag = cafm_flag
         @helpdesk_flag = helpdesk_flag

         initialize(service_ref,uom_vol,occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag )
         uomd
         clean
         subtotal1
         variance
         subtotal2
         cafm()
         helpdesk()
         subtotal3
         mobilisation
         tupe()
         year1
         manage()
         corporate
         year1total
         profit
         year1totalcharges
         subyearstotal
       end

    def benchmarkedcostssum(service_ref,uom_vol,occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag )
      @service_ref = service_ref
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag

      puts "UOM_VOL"
      puts @uom_vol

      initialize(service_ref,uom_vol,occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag )

      puts "UOM_VOL2"
      puts @uom_vol
      benchmarkedcosts
      benchclean
      benchsubtotal1
      benchvariation
      benchsubtotal2
      benchcafm()
      benchhelpdesk()
      benchsubtotal3
      benchmobilisation
      benchtupe()
      benchyear1
      benchmanage()
      benchcorporate
      benchyear1total
      benchprofit
      benchyear1totalcharges
      benchsubyearstotal
    end

  end
  end
