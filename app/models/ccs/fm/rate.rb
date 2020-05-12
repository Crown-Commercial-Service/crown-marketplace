module CCS
  module FM
    def self.table_name_prefix
      'fm_'
    end

    class Rate < ApplicationRecord
      include CommonRate

      private_class_method :service_for
    end
  end
end
