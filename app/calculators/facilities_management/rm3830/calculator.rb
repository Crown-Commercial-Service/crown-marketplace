# # facilities management calculator based on Damolas spreadsheet -  the first set framework calculations are repeated with a benchmark rate to give two values
# # cafm = computer aided facilities management
# # tupe = transfer underlying protection of employment

module FacilitiesManagement
  module RM3830
    class Calculator
      attr_writer :uom, :framework_rate
      attr_accessor :results

      @benchmark_rates = nil
      @framework_rates = nil

      # rubocop:disable Metrics/ParameterLists
      def initialize(contract_length_years, tupe_required, london_building, cafm_required, helpdesk_required, rates, rate_card, supplier_id = nil, building = nil)
        @contract_length_years = contract_length_years
        @subsequent_length_years = (contract_length_years - 1).clamp(0, 10)
        @tupe_required = tupe_required
        @london_building = london_building
        @cafm_required = cafm_required
        @helpdesk_required = helpdesk_required

        @benchmark_rates = rates[:benchmark_rates]
        @framework_rates = rates[:framework_rates]

        if supplier_id
          @supplier_id = supplier_id.to_sym
          @rate_card_discounts = rate_card.data[:Discounts][@supplier_id]
          @rate_card_variances = rate_card.data[:Variances][@supplier_id].transform_keys { |old_key| VARIANCE_KEY_TRANSFORMATION[old_key] || old_key }
          @rate_card_prices = rate_card.data[:Prices][@supplier_id]
        end

        @building_type = building.building_type.to_sym if building
      end
      # rubocop:enable Metrics/ParameterLists

      # rubocop:disable Naming/AccessorMethodName
      def set_calculation_mode(calculation_type)
        @calculation_type = calculation_type
        create_rates_and_variances_object
      end
      # rubocop:enable Naming/AccessorMethodName

      def initialize_service_variables(service_ref, service_standard, uom_vol, occupants)
        @service_ref = service_ref
        @rate_service_ref = @service_ref.gsub('.', '')
        @service_standard = service_standard
        @uom_vol = uom_vol.to_f
        @occupants = occupants
        @results = {}
        self
      end

      # rubocop:disable Metrics/AbcSize
      def calculate_total
        subtotal1 = uom_deliverables + cleaning_additional_cost
        subtotal1 *= @contract_length_years - @subsequent_length_years

        cafm = cafm(subtotal1)
        helpdesk = helpdesk(subtotal1)
        subtotal2 = subtotal1 + cafm + helpdesk

        london_variance = london_variance(subtotal2)
        subtotal3 = subtotal2 + london_variance

        mobilisation = mobilisation(subtotal3)
        tupe_risk_premium = tupe_risk_premium(subtotal3)
        year_1_deliverables = subtotal3 + mobilisation + tupe_risk_premium

        management_overhead = management_overhead(year_1_deliverables - tupe_risk_premium)
        corporate_overhead = corporate_overhead(year_1_deliverables)
        year_1_total_charges_subtotal = year_1_deliverables + management_overhead + corporate_overhead

        profit = profit(year_1_total_charges_subtotal)
        year_1_total_charges = year_1_total_charges_subtotal + profit

        subsequent_yearly_charge = subsequent_yearly_charge(year_1_total_charges, mobilisation)

        subsequent_years_total_charge = @subsequent_length_years * subsequent_yearly_charge

        if @calculation_type == :direct_award
          results[:subtotal1] = subtotal1
          results[:year_1_total_charges] = year_1_total_charges
          results[:cafm] = cafm
          results[:helpdesk] = helpdesk
          results[:london_variance] = london_variance
          results[:tupe_risk_premium] = tupe_risk_premium
          results[:management_overhead] = management_overhead
          results[:corporate_overhead] = corporate_overhead
          results[:profit] = profit
          results[:mobilisation] = mobilisation
          results[:subsequent_yearly_charge] = @subsequent_length_years.positive? ? subsequent_yearly_charge : 0
          results[:contract_length_years] = @contract_length_years
          results[:subsequent_length_years] = @subsequent_length_years
        end

        year_1_total_charges + subsequent_years_total_charge
      end
      # rubocop:enable Metrics/AbcSize

      private

      def uom_deliverables
        service_rate * @uom_vol * (1 - discount)
      end

      def discount
        return 0 unless @calculation_type == :direct_award

        @rate_card_discounts[@service_ref.to_sym][:'Disc %'].to_f
      end

      def cleaning_additional_cost
        return 0 if @occupants.zero?

        @occupants * @rates_and_variances['M146']
      end

      def london_variance(subtotal)
        return 0 unless @london_building

        subtotal * @rates_and_variances['M144'].to_f
      end

      def cafm(subtotal)
        return 0 unless @cafm_required

        subtotal * (@calculation_type == :direct_award ? @rate_card_prices[:'M.1'][@building_type].to_f : @rates_and_variances['M1'])
      end

      def helpdesk(subtotal)
        return 0 unless @helpdesk_required

        subtotal * (@calculation_type == :direct_award ? @rate_card_prices[:'N.1'][@building_type].to_f : @rates_and_variances['N1'])
      end

      def mobilisation(subtotal)
        subtotal * @rates_and_variances['B1'].to_f
      end

      def tupe_risk_premium(subtotal)
        return 0 unless @tupe_required

        subtotal * @rates_and_variances['M148'].to_f
      end

      def management_overhead(subtotal)
        subtotal * @rates_and_variances['M140']
      end

      def corporate_overhead(subtotal)
        subtotal * @rates_and_variances['M141']
      end

      def profit(subtotal)
        subtotal * @rates_and_variances['M142']
      end

      def subsequent_yearly_charge(year_1_total_charges, mobilisation)
        year_1_total_charges - (mobilisation * (1 + @rates_and_variances['M140'] + @rates_and_variances['M141']) * (1 + @rates_and_variances['M142']))
      end

      def subsequent_years_charges(year_1_total_charges, mobilisation)
        @subsequent_length_years * (year_1_total_charges - (mobilisation * (1 + @rates_and_variances['M140'] + @rates_and_variances['M141']) * (1 + @rates_and_variances['M142'])))
      end

      def service_rate
        case @calculation_type
        when :framework
          @framework_rates[@rate_service_ref] || @framework_rates["#{@rate_service_ref}-#{@service_standard}"]
        when :benchmark
          @benchmark_rates[@rate_service_ref] || @benchmark_rates["#{@rate_service_ref}-#{@service_standard}"]
        when :direct_award
          @rate_card_prices[@service_ref.to_sym][@building_type]
        end.to_f
      end

      def create_rates_and_variances_object
        @rates_and_variances = case @calculation_type
                               when :framework
                                 @framework_rates
                               when :benchmark
                                 @benchmark_rates
                               when :direct_award
                                 @rate_card_variances
                               end
      end

      VARIANCE_KEY_TRANSFORMATION = {
        'Profit %': 'M142',
        'Corporate Overhead %': 'M141',
        'Management Overhead %': 'M140',
        'Mobilisation Cost (DA %)': 'B1',
        'TUPE Risk Premium (DA %)': 'M148',
        'London Location Variance Rate (%)': 'M144',
        'Cleaning Consumables per Building User (£)': 'M146'
      }.freeze
    end
  end
end
