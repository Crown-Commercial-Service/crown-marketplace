module FacilitiesManagement
  module RM3830
    module Admin
      class ServiceRatesController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_slug, :set_rate_type, :full_services, :set_variances

        def show; end

        private

        def set_slug
          @slug = params[:slug]
        end

        def set_rate_type
          @rate_type = case @slug
                       when 'average-framework-rates'
                         :framework
                       when 'call-off-benchmark-rates'
                         :benchmark
                       end
        end

        def set_variances
          @variances = {
            td_overhead: rates.find_by(code: 'M.140'),
            td_corporate: rates.find_by(code: 'M.141'),
            td_profit: rates.find_by(code: 'M.142'),
            td_london: rates.find_by(code: 'M.144'),
            td_cleaning: rates.find_by(code: 'M.146'),
            td_tupe: rates.find_by(code: 'M.148'),
            td_mobilisation: rates.find_by(code: 'B.1')
          }
        end
      end
    end
  end
end
