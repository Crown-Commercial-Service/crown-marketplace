module FMCalculator
  class Calculator2
    def self.test
      # puts 'Twisty'
      logger = Logger.new(STDOUT)
      logger.debug 'Twisty'

      # current = CCS::FM::RateCard.last
      # logger.debug current.data['Prices']
      # current.data[current.data.keys[0]].each do |k, x|
      #   logger.debug k
      #   logger.debug x
      # end

      # pp = current.data['Prices'].keys.map { |k| current.data['Prices'][k]['C.1'] }
      # logger.debug pp

      logger.debug CCS::FM::RateCard.last.data['Prices'].count
      logger.debug CCS::FM::RateCard.last.data['Discount'].count
      logger.debug CCS::FM::RateCard.last.data['Variances'].count
    end
  end
end
