require 'rails_helper'
require 'FMcalculator/calculator'

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  before(:all) do
    # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
    $calc = FMCalculator::Calculator.new("G1",23000,125, 'Y','Y','Y','N')
  end

  describe 'unit of measurable deliverable calculation'
    it "calculate unit of unit of measurable deliverable" do

      x = $calc.uomd()
      expect(x).to eq(277491)

    end

  describe 'cleaning consumables if G1 or G3 selected'
    it "cleaning consumables if G1 or G3 selected" do
      x = $calc.clean()
      expect(x).to eq(3276)
    end

  describe 'subtotal1'
    it "make sure subtotal1 agrees with spreadsheet" do
      x = $calc.subtotal1()
      expect(x).to eq(280767)
    end

  describe 'london location variance'
    it "london location variance (framework)" do
       x = $calc.variance()
       expect(x).to eq(52816)
    end

    describe 'subtotal2'
      it "make sure subtotal2 agrees with spreadsheet" do
        x = $calc.subtotal2()
        expect(x).to eq(333583)
      end

    describe 'CAFM'
      it "CAFM" do
        x = $calc.cafm()
        expect(x).to eq(4850)
      end
 
     describe 'Helpdesk'
       it "Helpdesk" do
       helpdesk='n'
       x = $calc.helpdesk(helpdesk)
       expect(x).to eq(0)
      end

    describe 'subtotal3'
      it "make sure subtotal3 agrees with spreadsheet" do
        x = $calc.subtotal3()
        expect(x).to eq(338433)
      end

    describe 'mobilsation'
      it "Mobilisation" do
        x = $calc.mobilisation()
        expect(x).to eq(21998)
      end

    describe 'TUPE risk premium'
      it "TUPE risk premium" do
        x = $calc.tupe()
        expect(x).to eq(35142)
      end

     describe 'year1'
       it "Year 1 Deliverables" do
         x = $calc.year1()
         expect(x).to eq(395573)
       end

     describe 'Manaage'
       it "Management Overhead" do
       x = $calc.manage()
       expect(x).to eq(39915)
       end

      describe 'Corporate'
        it "Corporate Overhead" do
          x = $calc.corporate()
          expect(x).to eq(19709)
        end

      describe 'year1total'
        it "Total Year 1 Chargables subtotal" do
          x = $calc.year1total()
          expect(x).to eq(455197)
        end

       describe 'profit'
         it "proft" do
           x = $calc.profit()
           expect(x).to eq(21472)
         end

        describe 'year1total'
          it "Total Year 1 Chargables total" do
            x = $calc.year1totalcharges()
            expect(x).to eq(476669)
          end

         describe 'Subsequent years total'
           it "Subsequent years total" do
           x = $calc.subyearstotal()
           expect(x).to eq(899962)
           end

         describe 'total charges'
           it "total charges" do
             x = $calc.totalcharges()
             expect(x).to eq(1376631)
           end


           # -------------------------------------- Benchmarked Costs ----------------------------------------------
         describe 'benchmarked costs'
           it "benchmarked costs" do
             x = $calc.benchmarkedcosts()
             expect(x).to eq(119144)
         end

         describe 'benchmarked cleaning'
         it "benchmarked cleaning" do
           x = $calc.benchclean()
           expect(x).to eq(3276)
         end

         describe 'benchmarked subtotal1'
         it "benchmarked subtotal1" do
           x = $calc.benchsubtotal1()
           expect(x).to eq(122420)
         end

         describe 'benchmarked London location variation'
         it "benchmarked London location variation" do
           x = $calc.benchvariation()
           expect(x).to eq(23029)
         end

         describe 'benchmarked subtotal2'
         it "benchmarked subtotal2" do
           x = $calc.benchsubtotal2
           expect(x).to eq(145449)
         end

         describe 'benchmarked cafm'
         it "benchmarked cafm" do
           x = $calc.benchcafm
           puts "cafm"
           puts x
           expect(x).to eq(2115)
         end

         describe 'benchmarked helpdesk'
         it "benchmarked helpdesk" do
           x = $calc.benchhelpdesk()
           expect(x).to eq(0)
         end

         describe 'benchmarked subtotal3'
         it "benchmarked subtotal3" do
           x = $calc.benchsubtotal3()
           expect(x).to eq(147564)
         end

         describe 'benchmarked mobilsation'
         it "benchmark Mobilisation" do
           x = $calc.benchmobilisation()
           expect(x).to eq(9592)
         end

       describe 'benchmark TUPE risk premium'
         it "benchmark TUPE risk premium" do
           x = $calc.benchtupe()
           expect(x).to eq(15323)
         end

        describe 'benchmark year1'
          it "benchmark Year 1 Deliverables" do
            x = $calc.benchyear1()
            expect(x).to eq(172479)
          end

        describe 'benchmark Manaage'
          it "benchmark Management Overhead" do
          x = $calc.benchmanage()
          expect(x).to eq(17404)
          end

         describe 'benchmark Corporate'
           it "benchmark Corporate Overhead" do
             x = $calc.benchcorporate()
             expect(x).to eq(8594)
           end

         describe 'benchmark year1total'
           it "benchmark Total Year 1 Chargables subtotal" do
             x = $calc.benchyear1total()
             expect(x).to eq(198477)
           end

          describe 'benchmark profit'
            it "benchmark proft" do
              x = $calc.benchprofit()
              expect(x).to eq(9362)
            end

           describe 'benchmark year1total'
             it "benchmark Total Year 1 Chargables total" do
               x = $calc.benchyear1totalcharges()
               expect(x).to eq(207839)
             end

            describe 'benchmark Subsequent years total'
              it "benchmark Subsequent years total" do
              x = $calc.benchsubyearstotal()
              puts "benchsubtotal"
              puts x
              expect(x).to eq(392404)
              end

            describe 'benchmark total charges'
              it "benchmark total charges" do
                x = $calc.benchtotalcharges()
                expect(x).to eq(600243)
              end





            describe 'unit of measure of deliverables required '
              it "unit of measure of deliverables required " do
                $calc = FMCalculator::Calculator.new("G1",23000,125, 'Y','Y','Y','N')
                x = $calc.sumunitofmeasure("G1",23000,125, 'Y','Y','Y','N')
                puts x
                expect(x).to eq(899962)
              end


          end


