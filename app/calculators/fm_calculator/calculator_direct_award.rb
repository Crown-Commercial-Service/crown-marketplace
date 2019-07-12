module FMCalculator
  class CalculatorDirectAward
    def initialize
      # logger = Logger.new(STDOUT)
      # logger.info 'Twisty'

      # current = CCS::FM::RateCard.last
      # logger.debug current.data['Prices']
      # current.data[current.data.keys[0]].each do |k, x|
      #   logger.debug k
      #   logger.debug x
      # end

      rate_card = CCS::FM::RateCard.last

      # sheet_name == 'Prices'
      # data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
      @prices = rate_card.data['Prices'].keys.map { |k| rate_card.data['Prices'][k]['C.1'] }
      # logger.info @prices

      # sheet_name == 'Discount'
      # data['Discount'][rate_card['Supplier']][rate_card['Ref']] = rate_card
      @discount = rate_card.data['Discount'].keys.map { |k| rate_card.data['Discount'][k]['C.1'] }
      # logger.debug @discount

      # sheet_name == 'Variances'
      # data['Variances'][rate_card['Supplier']] = rate_card
      @variances = rate_card.data['Variances'].keys.map { |k| rate_card.data['Discount'][k] }
      # logger.debug @variances
    end

    def test
      # puts 'Twisty'
      # eligible = true if @building_type == 'STANDARD' && (@service_standard == 'A' || @service_standard.nil?) && @priced_at_framework.to_s == 'true' && Integer(@assessed_value) <= 1500000

      rates = CCS::FM::Rate.read_benchmark_rates

      sum_uom = 0
      sum_benchmark = 0

      @contract_length_years = 7
      code = 'A1'
      uom_value = 100
      occupants = 0
      @tupe_flag = 'N'
      @london_flag = 'N'
      @cafm_flag = 'Y'
      @helpdesk_flag = 'Y'

      calc_fm = FMCalculator::Calculator.new(rates, @contract_length_years, code, uom_value, occupants, @tupe_flag, @london_flag, @cafm_flag, @helpdesk_flag)
      sum_uom += calc_fm.sumunitofmeasure
      sum_benchmark += calc_fm.benchmarkedcostssum

      {
        sum_uom: sum_uom,
        sum_benchmark: sum_benchmark
      }
    end
  end
end
