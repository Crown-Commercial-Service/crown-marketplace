module FMCalculator
  class Calculator2
    def self.test
      # puts 'Twisty'
      logger = Logger.new(STDOUT)
      logger.debug 'Twisty'

      current = CCS::FM::RateCard.last
      logger.debug current.data['Prices']
      current.data[current.data.keys[0]].keys.each do |x|
        logger.debug x
      end
    end
  end
end
