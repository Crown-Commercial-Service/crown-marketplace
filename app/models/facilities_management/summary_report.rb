module FacilitiesManagement
  class SummaryReport

    def initialize(start_date, user_id, data)
      @start_date = start_date
      @user_id = user_id
      @data = data
      @posted_services = @data[:posted_services]
    end

    def calculate_services_for_buildings
      services_for_buildings



    end


    def with_pricing

      # CCS::FM::Rate.non_zero_rate
      services_with_pricing = CCS::FM::Rate.non_zero_rate.map(&:code)

      FacilitiesManagement::Service.all.select { |service| @posted_services.include? service.code and services_with_pricing.include? service.code }
    end


    def without_pricing
      # CCS::FM::Rate.zero_rate
      services_without_pricing = CCS::FM::Rate.zero_rate.map(&:code)

      FacilitiesManagement::Service.all.select { |service| @posted_services.include? service.code and services_without_pricing.include? service.code }
    end

    private

    def services_for_buildings


      @selected_services = FacilitiesManagement::Service.all.select { |service| @posted_services.include? service.code }

      # ------------------------------
      @building_data = CCS::FM::Building.buildings_for_user(@user_id)
      @building_data.each do | building |

        sumX = 0
        sumY = 0

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

        @selected_services.each do | service |
          # puts service.code
          # puts service.name
          # puts service.mandatory
          # puts service.mandatory?
          # puts service.work_package
          # puts service.work_package.code
          # puts service.work_package.name

          code = service.code.remove('.')
          calcFM = FMCalculator::Calculator.new(code, fm_gross_internal_area, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
          x1 = calcFM.sumunitofmeasure(code, fm_gross_internal_area, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
          y1 = calcFM.benchmarkedcostssum(code, fm_gross_internal_area, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)

          sumX += x1
          sumY += y1
        end

        p sumX
        p sumY
      end


      # ------------------------------

      locations = @data[:locations]
      services = @data[:services]

      fm_supplier_data = FMSupplierData.new
      @supplier_count = fm_supplier_data.long_list_supplier_count(locations, services)
      @suppliers_lot1a = fm_supplier_data.long_list_suppliers_lot(locations, services, '1a')
      @suppliers_lot1b = fm_supplier_data.long_list_suppliers_lot(locations, services, '1b')
      @suppliers_lot1c = fm_supplier_data.long_list_suppliers_lot(locations, services, '1c')

      @suppliers = ( @suppliers_lot1a || [] ) + ( @suppliers_lot1b || [] )  + ( @suppliers_lot1c || [] )

      # @supplier_count = [ @suppliers_lot1a, @suppliers_lot1b, @suppliers_lot1c ].max
      # puts @supplier_count

      calculate_fm
      calculate_fm_cleaning('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
    end

    def calculate_fm
      puts 'calculate_fm'

      # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
      calcFM = FMCalculator::Calculator.new('G1', 23000, 125, 'Y', 'Y', ' Y', 'N')

      x1 = calcFM.sumunitofmeasure('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
      # expect(X1).to eq(899962)

      x2 = calcFM.sumunitofmeasure('C5', 54, 0, 'Y', 'Y', 'Y', 'N')
      # expect(X2).to eq(36423)

      x3 = calcFM.sumunitofmeasure('C19', 0, 0, 'Y', 'Y', 'Y', 'N')
      # expect(X3).to eq(0)

      x4 = calcFM.sumunitofmeasure('E4', 450, 0, 'N', 'N', 'M', 'Y')
      # expect(X4).to eq(900)

      x5 = calcFM.sumunitofmeasure('K1', 75, 0, 'N', 'N', 'N', 'Y')
      # expect(X5).to eq(17651)

      x6 = calcFM.sumunitofmeasure('H4', 2350, 0, 'N', 'N', 'N', 'Y')
      # expect(X6).to eq(116470)

      x7 = calcFM.sumunitofmeasure('G5', 56757, 0, 'N', 'N', 'N', 'N')
      # expect(X7).to eq(359342)

      x8 = calcFM.sumunitofmeasure('K2', 125, 0, 'N', 'N', 'N', 'N')
      # expect(X8).to eq(67954)

      x9 = calcFM.sumunitofmeasure('K7', 680, 0, 'N', 'N', 'N', 'N')
      # expect(X9).to eq(38626)

      y1 = calcFM.benchmarkedcostssum('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
      # expect(Y1).to eq(392404)

      y2 = calcFM.benchmarkedcostssum('C5', 54, 0, 'Y', 'Y', 'Y', 'N')
      # expect(Y2).to eq(36423)

      y3 = calcFM.benchmarkedcostssum('C19', 0, 0, 'Y', 'Y', 'Y', 'N')
      # expect(Y3).to eq(0)

      y4 = calcFM.benchmarkedcostssum('E4', 450, 0, 'N', 'N', 'M', 'Y')
      # expect(Y4).to eq(900)
      y5 = calcFM.benchmarkedcostssum('K1', 75, 0, 'N', 'N', 'N', 'Y')
      # expect(Y5).to eq(17651)

      y6 = calcFM.benchmarkedcostssum('H4', 2350, 0, 'N', 'N', 'N', 'Y')
      # expect(Y6).to eq(116470)
      y7 = calcFM.benchmarkedcostssum('G5', 56757, 0, 'N', 'N', 'N', 'N')
      # expect(Y7).to eq(359342)

      y8 = calcFM.benchmarkedcostssum('K2', 125, 0, 'N', 'N', 'N', 'N')
      # §expect(Y8).to eq(67954)

      y9 = calcFM.benchmarkedcostssum('K7', 680, 0, 'N', 'N', 'N', 'N')
      # expect(Y9).to eq(38626)

      sumX = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9
      # expect(SumX).to eq(1537328)

      sumY = y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8 + y9
      # expect(SumY).to eq(1029770)
    end

    # (service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
    def calculate_fm_cleaning(service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)
      puts 'calculate_fm_cleaning'

      # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
      # calc = FMCalculator::Calculator.new('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
      calc = FMCalculator::Calculator.new(service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag)

      x = calc.uomd
      # expect(x).to eq(277491)
      x = calc.clean
      # expect(x).to eq(3276)
      x = calc.subtotal1
      # expect(x).to eq(280767)
      x = calc.variance
      # expect(x).to eq(52816)
      x = calc.subtotal2
      # expect(x).to eq(333583)
      x = calc.cafm
      # expect(x).to eq(4850)
      x = calc.helpdesk
      # expect(x).to eq(0)
      x = calc.subtotal3
      # expect(x).to eq(338433)
      x = calc.mobilisation
      # expect(x).to eq(21998)
      x = calc.tupe
      # expect(x).to eq(35142)
      x = calc.year1
      # expect(x).to eq(395573)
      x = calc.manage
      # expect(x).to eq(39915)
      x = calc.corporate
      # expect(x).to eq(19709)
      x = calc.year1total
      # expect(x).to eq(455197)
      x = calc.profit
      # expect(x).to eq(21472)
      x = calc.year1totalcharges
      # expect(x).to eq(476669)
      x = calc.subyearstotal
      x = calc.totalcharges
      # expect(x).to eq(899962)
      # expect(x).to eq(1376631)
      # -------------------------------------- Benchmarked Costs ----------------------------------------------
      x = calc.benchmarkedcosts
      # expect(x).to eq(119144)
      x = calc.benchclean
      # expect(x).to eq(3276)
      x = calc.benchsubtotal1
      # expect(x).to eq(122420)
      x = calc.benchvariation
      # expect(x).to eq(23029)
      x = calc.benchsubtotal2
      # expect(x).to eq(145449)
      x = calc.benchcafm
      # expect(x).to eq(0)
      # expect(x).to eq(2115)
      x = calc.benchhelpdesk
      x = calc.benchsubtotal3
      # expect(x).to eq(147564)
      x = calc.benchmobilisation
      # expect(x).to eq(9592)
      x = calc.benchtupe
      # expect(x).to eq(15323)
      x = calc.benchyear1
      # expect(x).to eq(172479)
      x = calc.benchmanage
      # expect(x).to eq(17404)
      x = calc.benchcorporate
      # expect(x).to eq(8594)
      x = calc.benchyear1total
      # expect(x).to eq(198477)
      x = calc.benchprofit
      # expect(x).to eq(9362)
      x = calc.benchyear1totalcharges
      # expect(x).to eq(207839)
      x = calc.benchsubyearstotal
      # expect(x).to eq(392404)
      x = calc.benchtotalcharges
      # expect(x).to eq(600243)

    end
  end
end
