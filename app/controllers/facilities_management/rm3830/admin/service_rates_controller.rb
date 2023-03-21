module FacilitiesManagement
  module RM3830
    module Admin
      class ServiceRatesController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_framework_has_expired
        before_action :redirect_if_framework_has_expired, only: :update
        before_action :set_slug, :set_rate_type, :full_services, :set_variances, :initialise_errors

        def edit; end

        def update
          apply_and_collect_errors(params[:rates])

          if @errors.any?
            @errors = @errors.first
            render :edit
          else
            save_updated_rates
            redirect_to facilities_management_rm3830_admin_path
          end
        end

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

        def initialise_errors
          @errors = []
        end

        def apply_and_collect_errors(data)
          @full_services.each do |service|
            service['work_package'].each do |package|
              package['rates'].each do |rate|
                rate.send("#{@rate_type}=", data[rate.id])
                @errors << rate.errors if rate.invalid? @rate_type
              end
            end
          end

          @variances.each do |_label, rate|
            rate.send("#{@rate_type}=", data[rate.id])
            @errors << rate.errors if rate.invalid? @rate_type
          end
        end

        def save_updated_rates
          @full_services.each do |service|
            service['work_package'].each do |package|
              package['rates'].each { |rate| rate.save if rate.changed? }
            end
          end

          @variances.each { |_label, rate| rate.save if rate.changed? }
        end

        def redirect_if_framework_has_expired
          redirect_to edit_facilities_management_rm3830_admin_service_rate_path if @framework_has_expired
        end
      end
    end
  end
end
