module FacilitiesManagement
  module RM6232
    class Service < ApplicationRecord
      belongs_to :work_package, foreign_key: :work_package_code, inverse_of: :services
    end
  end
end
