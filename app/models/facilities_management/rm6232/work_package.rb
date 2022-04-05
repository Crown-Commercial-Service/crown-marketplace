module FacilitiesManagement
  module RM6232
    class WorkPackage < ApplicationRecord
      scope :selectable, -> { where(selectable: true).order(:code) }

      has_many :services, foreign_key: :work_package_code, inverse_of: :work_package, dependent: :destroy
    end
  end
end
