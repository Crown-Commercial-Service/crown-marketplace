module FacilitiesManagement
  module Admin
    class Rates < ApplicationRecord
      self.table_name = 'fm_rates'

      validates :framework, numericality: true, allow_blank: true, on: :framework
      validate :validate_framework_in_range, on: :framework

      validates :benchmark, numericality: true, allow_blank: true, on: :benchmark
      validate :validate_benchmark_in_range, on: :benchmark

      private

      def validate_framework_in_range
        return unless range_validation_required?

        errors.add(:framework, :out_of_range) if framework.to_f > 1
      end

      def validate_benchmark_in_range
        return unless range_validation_required?

        errors.add(:benchmark, :out_of_range) if benchmark.to_f > 1
      end

      def range_validation_required?
        RATES_USING_PERCENTAGE.include?(code) && errors.none?
      end

      RATES_USING_PERCENTAGE = %w[M.1 N.1 M.140 M.141 M.142 M.144 M.148 B.1].freeze
    end
  end
end
