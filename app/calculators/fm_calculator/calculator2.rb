module FMCalculator
  class Calculator2
    def self.test
      # puts 'Twisty'
      logger = Logger.new(STDOUT)
      logger.debug 'Twisty'

      current = CCS::FM::RateCard.last
      logger.debug current.data['Prices']
      current.data[current.data.keys[0]].each do |k, x|
        logger.debug k
        logger.debug x
      end

      pp = current.data['Prices'].select { |p| p['Service Ref'] == 'C.13' }
      logger.debug pp
    end
  end
end
