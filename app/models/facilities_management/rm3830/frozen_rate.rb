module FacilitiesManagement
  module RM3830
    class FrozenRate < ApplicationRecord
      include CommonRate

      private_class_method :service_for
    end
  end
end
