module FacilitiesManagement
  module RM3830
    class Rate < ApplicationRecord
      include CommonRate

      private_class_method :service_for
    end
  end
end
