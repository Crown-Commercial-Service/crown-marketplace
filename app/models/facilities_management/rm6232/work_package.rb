module FacilitiesManagement
  module RM6232
    class WorkPackage < ApplicationRecord
      scope :selectable, -> { where(selectable: true).order(:code) }

      has_many :services, foreign_key: :work_package_code, inverse_of: :work_package, dependent: :destroy

      # This is because of the nature of CAFM services
      # You can find more information at https://crowncommercialservice.atlassian.net/l/c/XW2DSi72
      def selectable_services
        return services.order(:sort_order) unless code == 'Q'

        services.where(code: 'Q.3').order(:sort_order)
      end

      def supplier_services
        return services.order(:sort_order) unless code == 'Q'

        services.where.not(code: 'Q.3').order(:sort_order)
      end
    end
  end
end
