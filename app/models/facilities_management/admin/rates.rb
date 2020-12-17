module FacilitiesManagement
  module Admin
    class Rates < ApplicationRecord
      self.table_name = 'fm_rates'

      validates :framework, numericality: true, allow_blank: true, on: :framework
      validates :benchmark, numericality: true, allow_blank: true, on: :benchmark
    end
  end
end
