module CCS
  module FM
    # CCS::FM::Rate.all

    def self.table_name_prefix
      'fm_'
    end

    class Rate < ApplicationRecord
      # attr_reader :benchmark_rates, :framework_rates

      # usage:
      # CCS::FM::Rate.zero_rate
      # CCS::FM::Rate.zero_rate.map(&:code)
      def self.zero_rate
        where(framework: 0, benchmark: 0)
      end

      # CCS::FM::Rate.non_zero_rate
      # CCS::FM::Rate.non_zero_rate.map(&:code)
      def self.non_zero_rate
        where('framework <> 0 and  benchmark <> 0')
      end

      # read in the benchmark and framework rates - these were taken from the Damolas spreadsheet and put in the postgres database numbers are to 15dp
      #
      # usage:
      #        CCS::FM::Rate.read_benchmark_rates
      # rubocop:disable Rails/FindEach
      def self.read_benchmark_rates
        benchmark_rates = {}
        framework_rates = {}
        all.each do |row|
          code = row['code'].remove('.')
          benchmark_rates[code] = row['benchmark'].to_f
          framework_rates[code] = row['framework'].to_f
        end

        {
          benchmark_rates: benchmark_rates,
          framework_rates: framework_rates
        }
      end
      # rubocop:enable Rails/FindEach
    end
  end
end
