module FacilitiesManagement
  module Admin
    class Rates < ApplicationRecord
      self.table_name = 'fm_rates'

      validates :framework, numericality: true, allow_blank: true, on: :framework
      validates :framework, numericality: { less_than_or_equal_to: 1 }, allow_blank: true, on: :framework, if: -> { range_validation_required? }

      validates :benchmark, numericality: true, allow_blank: true, on: :benchmark
      validates :benchmark, numericality: { less_than_or_equal_to: 1 }, allow_blank: true, on: :benchmark, if: -> { range_validation_required? }

      private

      def range_validation_required?
        RATES_USING_PERCENTAGE.include?(code) && errors.none?
      end

      RATES_USING_PERCENTAGE = %w[M.1 N.1 M.140 M.141 M.142 M.144 M.148 B.1].freeze
    end
  end
end
