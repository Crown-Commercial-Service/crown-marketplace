require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Calculator do
  let(:rates) { FacilitiesManagement::RM3830::Rate.read_benchmark_rates }
  let(:rate_card) { FacilitiesManagement::RM3830::RateCard.latest }

  # rubocop:disable RSpec/NestedGroups
  describe '.calculate_total' do
    let(:calculator) { described_class.new(contract_length, tupe_required, london_building, cafm_required, helpdesk_required, rates, rate_card) }
    let(:tupe_required) { false }
    let(:london_building) { false }
    let(:cafm_required) { false }
    let(:helpdesk_required) { false }
    let(:service_standard) { nil }
    let(:occupants) { 0 }

    before do
      calculator.set_calculation_mode(calculation_mode)
      calculator.initialize_service_variables(service_ref, service_standard, uom_vol, occupants)
    end

    context 'when calculating the framework cost' do
      let(:calculation_mode) { :framework }

      context 'and there is tupe, london and cafm' do
        let(:tupe_required) { true }
        let(:london_building) { true }
        let(:cafm_required) { true }

        context 'and the contract length is 3 years' do
          let(:contract_length) { 3 }

          context 'and the service is G.1' do
            let(:service_ref) { 'G.1' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 23000 }
            let(:occupants) { 125 }

            it 'returns £1,347,788.51' do
              expect(calculator.calculate_total.round(2)).to eq 1347788.51
            end
          end

          context 'and the service is C.5' do
            let(:service_ref) { 'C.5' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 54 }

            it 'returns £54,566.71' do
              expect(calculator.calculate_total.round(2)).to eq 54566.71
            end
          end

          context 'and the service is C.19' do
            let(:service_ref) { 'C.19' }
            let(:uom_vol) { 0 }

            it 'returns £0' do
              expect(calculator.calculate_total.round(2)).to eq 0
            end
          end
        end

        context 'when the contract length is 9 months' do
          let(:contract_length) { 9.0 / 12 }

          context 'and the service is G.3' do
            let(:service_ref) { 'G.3' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 12000 }
            let(:occupants) { 99 }

            it 'returns £224,115.92' do
              expect(calculator.calculate_total.round(2)).to eq 224115.92
            end
          end

          context 'and the service is I.1' do
            let(:service_ref) { 'I.1' }
            let(:uom_vol) { 300 }

            it 'returns £5,020.78' do
              expect(calculator.calculate_total.round(2)).to eq 5020.78
            end
          end

          context 'and the service is J.4' do
            let(:service_ref) { 'J.4' }
            let(:uom_vol) { 600 }

            it 'returns £10,538.59' do
              expect(calculator.calculate_total.round(2)).to eq 10538.59
            end
          end
        end

        context 'when the contract length is 18 months' do
          let(:contract_length) { 1 + (6.0 / 12) }

          context 'and the service is G.5' do
            let(:service_ref) { 'G.5' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 60000 }

            it 'returns £378,899.50' do
              expect(calculator.calculate_total.round(2)).to eq 378899.5
            end
          end

          context 'and the service is F.1' do
            let(:service_ref) { 'F.1' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 1060 }

            it 'returns £0' do
              expect(calculator.calculate_total.round(2)).to eq 0
            end
          end

          context 'and the service is C.19' do
            let(:service_ref) { 'K.3' }
            let(:uom_vol) { 5768 }

            it 'returns £2,481,877.23' do
              expect(calculator.calculate_total.round(2)).to eq 2481877.23
            end
          end
        end
      end

      context 'and there is helpdesk' do
        let(:helpdesk_required) { true }

        context 'and the contract length is 3 years' do
          let(:contract_length) { 3 }

          context 'and the service is E.4' do
            let(:service_ref) { 'E.4' }
            let(:uom_vol) { 450 }

            it 'returns £1,349.41' do
              expect(calculator.calculate_total.round(2)).to eq 1349.41
            end
          end

          context 'and the service is K.1' do
            let(:service_ref) { 'K.1' }
            let(:uom_vol) { 75 }

            it 'returns £26,670.60' do
              expect(calculator.calculate_total.round(2)).to eq 26670.60
            end
          end

          context 'and the service is H.4' do
            let(:service_ref) { 'H.4' }
            let(:uom_vol) { 2350 }

            it 'returns £175,997.29' do
              expect(calculator.calculate_total.round(2)).to eq 175997.29
            end
          end
        end

        context 'when the contract length is 9 months' do
          let(:contract_length) { 9.0 / 12 }

          context 'and the service is E.1' do
            let(:service_ref) { 'E.1' }
            let(:uom_vol) { 10000 }

            it 'returns £20,709.75' do
              expect(calculator.calculate_total.round(2)).to eq 20709.75
            end
          end

          context 'and the service is K.7' do
            let(:service_ref) { 'K.7' }
            let(:uom_vol) { 4500 }

            it 'returns £99,434.93' do
              expect(calculator.calculate_total.round(2)).to eq 99434.93
            end
          end

          context 'and the service is H.7' do
            let(:service_ref) { 'H.7' }
            let(:uom_vol) { 9900 }

            it 'returns £0' do
              expect(calculator.calculate_total.round(2)).to eq 0
            end
          end
        end

        context 'when the contract length is 18 months' do
          let(:contract_length) { 1 + (6.0 / 12) }

          context 'and the service is E.2' do
            let(:service_ref) { 'E.2' }
            let(:uom_vol) { 123 }

            it 'returns £248.97' do
              expect(calculator.calculate_total.round(2)).to eq 248.97
            end
          end

          context 'and the service is K.2' do
            let(:service_ref) { 'K.2' }
            let(:uom_vol) { 456 }

            it 'returns £192,864.06' do
              expect(calculator.calculate_total.round(2)).to eq 192864.06
            end
          end

          context 'and the service is H.2' do
            let(:service_ref) { 'H.2' }
            let(:uom_vol) { 7890 }

            it 'returns £0' do
              expect(calculator.calculate_total.round(2)).to eq 0
            end
          end
        end
      end

      context 'and there are no additional options' do
        context 'when the contract length is 3 years' do
          let(:contract_length) { 3 }

          context 'and the service is G.5' do
            let(:service_ref) { 'G.5' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 56757 }

            it 'returns £543,278.80' do
              expect(calculator.calculate_total.round(2)).to eq 543278.80
            end
          end

          context 'and the service is K.2' do
            let(:service_ref) { 'K.2' }
            let(:uom_vol) { 125 }

            it 'returns £102,667.13' do
              expect(calculator.calculate_total.round(2)).to eq 102667.13
            end
          end

          context 'and the service is K.7' do
            let(:service_ref) { 'K.7' }
            let(:uom_vol) { 680 }

            it 'returns £58,357.98' do
              expect(calculator.calculate_total.round(2)).to eq 58357.98
            end
          end
        end
      end
    end

    context 'when calculating the benchmark cost' do
      let(:calculation_mode) { :benchmark }

      context 'and there is tupe, london and cafm' do
        let(:tupe_required) { true }
        let(:london_building) { true }
        let(:cafm_required) { true }

        context 'when the contract length is 3 years' do
          let(:contract_length) { 3 }

          context 'and the service is G.1' do
            let(:service_ref) { 'G.1' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 23000 }
            let(:occupants) { 125 }

            it 'returns £582,256.40' do
              expect(calculator.calculate_total.round(2)).to eq 582256.40
            end
          end

          context 'and the service is C.5' do
            let(:service_ref) { 'C.5' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 54 }

            it 'returns £54,045.06' do
              expect(calculator.calculate_total.round(2)).to eq 54045.06
            end
          end

          context 'and the service is C.19' do
            let(:service_ref) { 'C.19' }
            let(:uom_vol) { 0 }

            it 'returns £0' do
              expect(calculator.calculate_total.round(2)).to eq 0
            end
          end
        end

        context 'when the contract length is 9 months' do
          let(:contract_length) { 9.0 / 12 }

          context 'and the service is G.3' do
            let(:service_ref) { 'G.3' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 12000 }
            let(:occupants) { 99 }

            it 'returns £230,590.07' do
              expect(calculator.calculate_total.round(2)).to eq 230590.07
            end
          end

          context 'and the service is I.1' do
            let(:service_ref) { 'I.1' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 300 }

            it 'returns £5,165.82' do
              expect(calculator.calculate_total.round(2)).to eq 5165.82
            end
          end

          context 'and the service is J.4' do
            let(:service_ref) { 'J.4' }
            let(:uom_vol) { 600 }

            it 'returns £10,843.03' do
              expect(calculator.calculate_total.round(2)).to eq 10843.03
            end
          end
        end

        context 'when the contract length is 18 months' do
          let(:contract_length) { 1 + (6.0 / 12) }

          context 'and the service is G.5' do
            let(:service_ref) { 'G.5' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 60000 }

            it 'returns £382,561.09' do
              expect(calculator.calculate_total.round(2)).to eq 382561.09
            end
          end

          context 'and the service is F.1' do
            let(:service_ref) { 'F.1' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 1060 }

            it 'returns £334.07' do
              expect(calculator.calculate_total.round(2)).to eq 334.07
            end
          end

          context 'and the service is K.3' do
            let(:service_ref) { 'K.3' }
            let(:uom_vol) { 5768 }

            it 'returns £2,505,861.47' do
              expect(calculator.calculate_total.round(2)).to eq 2505861.47
            end
          end
        end
      end

      context 'and there is helpdesk' do
        let(:helpdesk_required) { true }

        context 'when the contract length is 3 years' do
          let(:contract_length) { 3 }

          context 'and the service is E.4' do
            let(:service_ref) { 'E.4' }
            let(:uom_vol) { 450 }

            it 'returns £1,339.04' do
              expect(calculator.calculate_total.round(2)).to eq 1339.04
            end
          end

          context 'and the service is K.1' do
            let(:service_ref) { 'K.1' }
            let(:uom_vol) { 75 }

            it 'returns £26,465.65' do
              expect(calculator.calculate_total.round(2)).to eq 26465.65
            end
          end

          context 'and the service is H.4' do
            let(:service_ref) { 'H.4' }
            let(:uom_vol) { 2350 }

            it 'returns £174,644.85' do
              expect(calculator.calculate_total.round(2)).to eq 174644.85
            end
          end
        end

        context 'when the contract length is 9 months' do
          let(:contract_length) { 9.0 / 12 }

          context 'and the service is E.1' do
            let(:service_ref) { 'E.1' }
            let(:uom_vol) { 10000 }

            it 'returns £21,422.25' do
              expect(calculator.calculate_total.round(2)).to eq 21422.25
            end
          end

          context 'and the service is K.7' do
            let(:service_ref) { 'K.7' }
            let(:uom_vol) { 4500 }

            it 'returns £102,855.88' do
              expect(calculator.calculate_total.round(2)).to eq 102855.88
            end
          end

          context 'and the service is H.7' do
            let(:service_ref) { 'H.7' }
            let(:uom_vol) { 9900 }

            it 'returns £863.68' do
              expect(calculator.calculate_total.round(2)).to eq 863.68
            end
          end
        end

        context 'when the contract length is 18 months' do
          let(:contract_length) { 1 + (6.0 / 12) }

          context 'and the service is E.2' do
            let(:service_ref) { 'E.2' }
            let(:uom_vol) { 123 }

            it 'returns £252.29' do
              expect(calculator.calculate_total.round(2)).to eq 252.29
            end
          end

          context 'and the service is K.2' do
            let(:service_ref) { 'K.2' }
            let(:uom_vol) { 456 }

            it 'returns £195,440.68' do
              expect(calculator.calculate_total.round(2)).to eq 195440.68
            end
          end

          context 'and the service is H.2' do
            let(:service_ref) { 'H.2' }
            let(:uom_vol) { 7890 }

            it 'returns £32,217.49' do
              expect(calculator.calculate_total.round(2)).to eq 32217.49
            end
          end
        end
      end

      context 'and there are no additional options' do
        context 'when the contract length is 3 years' do
          let(:contract_length) { 3 }

          context 'and the service is G.5' do
            let(:service_ref) { 'G.5' }
            let(:service_standard) { 'A' }
            let(:uom_vol) { 56757 }

            it 'returns £539,104.00' do
              expect(calculator.calculate_total.round(2)).to eq 539104.00
            end
          end

          context 'and the service is K.2' do
            let(:service_ref) { 'K.2' }
            let(:uom_vol) { 125 }

            it 'returns £101,878.19' do
              expect(calculator.calculate_total.round(2)).to eq 101878.19
            end
          end

          context 'and the service is K.7' do
            let(:service_ref) { 'K.7' }
            let(:uom_vol) { 680 }

            it 'returns £57,909.54' do
              expect(calculator.calculate_total.round(2)).to eq 57909.54
            end
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe 'calculate total with different building types' do
    let(:supplier_id) { 'ef44b65d-de46-4297-8d2c-2c6130cecafc' }
    let(:calculator) { described_class.new(2.5, false, false, false, false, rates, rate_card, supplier_id, building) }
    let(:building) { create(:facilities_management_building, building_type:) }
    let(:service_standard) { 'A' }
    let(:occupants) { 0 }

    before do
      calculator.set_calculation_mode(:direct_award)
      calculator.initialize_service_variables(service_ref, service_standard, uom_vol, occupants)
    end

    context 'and the service code is G.1' do
      let(:service_ref) { 'G.1' }
      let(:uom_vol) { 7932 }
      let(:occupants) { 360 }

      context 'when the building type is General office - Customer Facing' do
        let(:building_type) { 'General office - Customer Facing' }

        it 'returns £316,167.27' do
          expect(calculator.calculate_total.round(2)).to eq 316167.27
        end
      end

      context 'when the building type is Warehouses' do
        let(:building_type) { 'Warehouses' }

        it 'returns £182,464.84' do
          expect(calculator.calculate_total.round(2)).to eq 182464.84
        end
      end

      context 'when the building type is Universities and Colleges' do
        let(:building_type) { 'Universities and Colleges' }

        it 'returns £239,765.88' do
          expect(calculator.calculate_total.round(2)).to eq 239765.88
        end
      end
    end

    context 'and the service is G.2' do
      let(:service_ref) { 'G.2' }
      let(:uom_vol) { 4712 }

      context 'when the building type is General office - Customer Facing' do
        let(:building_type) { 'General office - Customer Facing' }

        it 'returns £7,375.29' do
          expect(calculator.calculate_total.round(2)).to eq 7375.29
        end
      end

      context 'when the building type is Restaurant and Catering Facilities' do
        let(:building_type) { 'Restaurant and Catering Facilities' }

        it 'returns £7,375.29' do
          expect(calculator.calculate_total.round(2)).to eq 7375.29
        end
      end

      context 'when the building type is Nursing and Care Homes' do
        let(:building_type) { 'Nursing and Care Homes' }

        it 'returns £7,375.29' do
          expect(calculator.calculate_total.round(2)).to eq 7375.29
        end
      end
    end

    context 'and the service is E.3' do
      let(:service_ref) { 'G.15' }
      let(:uom_vol) { 1997 }

      context 'when the building type is General office - Non Customer Facing' do
        let(:building_type) { 'General office - Non Customer Facing' }

        it 'returns £1,322.42' do
          expect(calculator.calculate_total.round(2)).to eq 1322.42
        end
      end

      context 'when the building type is Primary School' do
        let(:building_type) { 'Primary School' }

        it 'returns £1,469.36' do
          expect(calculator.calculate_total.round(2)).to eq 1469.36
        end
      end

      context 'when the building type is Community - Doctors, Dentist, Health Clinic' do
        let(:building_type) { 'Community - Doctors, Dentist, Health Clinic' }

        it 'returns £1,653.03' do
          expect(calculator.calculate_total.round(2)).to eq 1653.03
        end
      end
    end
  end

  describe 'subsequent_length_years' do
    let(:calculator) { described_class.new(contract_length, false, false, false, false, rates, rate_card) }

    context 'when the contract length years is 1' do
      let(:contract_length) { 1 }

      it 'is set to 0' do
        expect(calculator.instance_variable_get(:@subsequent_length_years)).to eq 0
      end
    end

    context 'when the contract length years is 1/12' do
      let(:contract_length) { 1 / 12.0 }

      it 'is set to 0' do
        expect(calculator.instance_variable_get(:@subsequent_length_years)).to eq 0
      end
    end

    context 'when the contract length years is 11/12' do
      let(:contract_length) { 11 / 12.0 }

      it 'is set to 0' do
        expect(calculator.instance_variable_get(:@subsequent_length_years)).to eq 0
      end
    end

    context 'when the contract length years is 3 6/12' do
      let(:contract_length) { 3 + (6 / 12.0) }

      it 'is set to 2.5' do
        expect(calculator.instance_variable_get(:@subsequent_length_years)).to eq 2.5
      end
    end

    context 'when the contract length years is 1 1/12' do
      let(:contract_length) { 1 + (1 / 12.0) }

      it 'is set to 0.083' do
        expect(calculator.instance_variable_get(:@subsequent_length_years).round(3)).to eq 0.083
      end
    end

    context 'when the contract length years is 4 7/12' do
      let(:contract_length) { 4 + (7 / 12.0) }

      it 'is set to 3.583' do
        expect(calculator.instance_variable_get(:@subsequent_length_years).round(3)).to eq 3.583
      end
    end
  end
end
