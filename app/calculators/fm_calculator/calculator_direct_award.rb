module FMCalculator
  class CalculatorDirectAward
    # rubocop:disable Metrics/AbcSize
    def initialize
      logger = Logger.new(STDOUT)
      logger.debug 'Twisty'

      # current = CCS::FM::RateCard.last
      # logger.debug current.data['Prices']
      # current.data[current.data.keys[0]].each do |k, x|
      #   logger.debug k
      #   logger.debug x
      # end

      rate_card = CCS::FM::RateCard.last

      # sheet_name == 'Prices'
      # data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
      prices = rate_card.data['Prices'].keys.map { |k| rate_card.data['Prices'][k]['C.1'] }
      logger.debug prices

      # sheet_name == 'Discount'
      # data['Discount'][rate_card['Supplier']][rate_card['Ref']] = rate_card
      discount = rate_card.data['Discount'].keys.map { |k| rate_card.data['Discount'][k]['C.1'] }
      logger.debug discount

      # sheet_name == 'Variances'
      # data['Variances'][rate_card['Supplier']] = rate_card
      variances = rate_card.data['Variances'].keys.map { |k| rate_card.data['Discount'][k] }
      logger.debug variances
    end
    # rubocop:enable Metrics/AbcSize

    def test
      # puts 'Twisty'
    end
  end
end
