module CommonRate
  extend ActiveSupport::Concern

  class_methods do
    def framework_rate_for(service_code, standard = 'A')
      service_for(service_code, standard).framework
    end

    def benchmark_rate_for(service_code, standard = 'A')
      service_for(service_code, standard).benchmark
    end

    # usage:
    # CCS::FM::Rate.zero_rate
    # CCS::FM::Rate.zero_rate.map(&:code)
    def zero_rate
      where(framework: 0, benchmark: 0)
    end

    # CCS::FM::Rate.non_zero_rate
    # CCS::FM::Rate.non_zero_rate.map(&:code)
    def non_zero_rate
      where('framework <> 0 and  benchmark <> 0')
    end

    def priced_at_framework(code, standard)
      find_by(code: code, standard: standard)&.framework.present?
    end

    # read in the benchmark and framework rates - these were taken from the Damolas spreadsheet and put in the postgres database numbers are to 15dp
    #
    # usage:
    #        CCS::FM::Rate.read_benchmark_rates
    # rubocop:disable Rails/FindEach
    def read_benchmark_rates
      benchmark_rates = {}
      framework_rates = {}
      all.each do |row|
        code_and_standard = "#{row['code'].remove('.')}#{'-' + row['standard'].to_s if row['standard']}"
        benchmark_rates[code_and_standard] = row['benchmark'].to_f
        framework_rates[code_and_standard] = row['framework'].to_f
      end
      {
        benchmark_rates: benchmark_rates,
        framework_rates: framework_rates
      }
    end
    # rubocop:enable Rails/FindEach

    def service_for(service_code, standard)
      find_by(code: service_code, standard: standard) || find_by(code: service_code)
    end
  end
end
