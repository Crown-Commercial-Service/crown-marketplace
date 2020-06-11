module FacilitiesManagement
  module Admin
    class SupplierRatesController < FacilitiesManagement::FrameworkController
      before_action :full_services, :variances, :init_errors

      def update_supplier_benchmark_rates
        all_errors = apply_and_collect_errors(params[:rates], :benchmark)

        if all_errors.any?
          @errors = all_errors.first
          render :supplier_benchmark_rates
        else
          save_updated_rates
          flash[:success] = 'Rates successfully updated'
          redirect_to facilities_management_admin_path
        end
      end

      def update_supplier_framework_rates
        all_errors = apply_and_collect_errors(params[:rates], :framework)

        if all_errors.any?
          @errors = all_errors.first
          render :supplier_framework_rates
        else
          save_updated_rates
          flash[:success] = 'Rates successfully updated'
          redirect_to facilities_management_admin_path
        end
      end

      private

      def variances
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

      def init_errors
        @errors = []
      end

      def apply_and_collect_errors(data, attribute)
        all_errors = []

        @full_services.each do |service|
          service['work_package'].each do |package|
            package['rates'].each do |rate|
              rate.send("#{attribute}=", data[rate.id])
              all_errors << rate.errors if rate.invalid?
            end
          end
        end

        @variances.each do |_label, rate|
          rate.send("#{attribute}=", data[rate.id])
          all_errors << rate.errors if rate.invalid?
        end

        all_errors
      end

      def save_updated_rates
        @full_services.each do |service|
          service['work_package'].each do |package|
            package['rates'].each { |rate| rate.save if rate.changed? }
          end
        end

        @variances.each { |_label, rate| rate.save if rate.changed? }
      end
    end
  end
end
