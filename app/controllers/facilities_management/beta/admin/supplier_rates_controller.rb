module FacilitiesManagement
  module Beta
    module Admin
      class SupplierRatesController < FacilitiesManagement::Beta::FrameworkController
        before_action :full_services, :variances, :init_errors

        def update_supplier_benchmark_rates
          all_errors = apply_and_collect_errors(params[:rates], :benchmark)

          if all_errors.any?
            @errors = all_errors.first
            render :supplier_benchmark_rates
          else
            save_updated_rates
            flash[:success] = 'Rates successfully updated'
            redirect_to facilities_management_beta_admin_path
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
            redirect_to facilities_management_beta_admin_path
          end
        end

        private

        def variances
          sections = {
            td_overhead: 'M.140',
            td_corporate: 'M.141',
            td_profit: 'M.142',
            td_london: 'M.144',
            td_cleaning: 'M.146',
            td_tupe: 'M.148',
            td_mobilisation: 'B.1'
          }

          vars = rates.where(code: sections.values)

          @variances = sections.reduce({}) do |memo, (key, val)|
            memo.merge(key => vars.find { |r| r.code == val })
          end
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
          values = []

          @full_services.each do |service|
            service['work_package'].each do |package|
              package['rates'].each { |rate| values << value_clause(rate) if rate.changed? }
            end
          end

          @variances.each { |_label, rate| values << value_clause(rate) if rate.changed? }

          ActiveRecord::Base.transaction { batch_update(values) }
        end

        def value_clause(rate)
          "(#{null_if_nil(rate.benchmark)}, #{null_if_nil(rate.framework)}, UUID('#{rate.id}'))"
        end

        def null_if_nil(val)
          val.nil? ? 'NULL' : val
        end

        def batch_update(values)
          sql = 'UPDATE fm_rates AS r SET benchmark = v.benchmark, framework = v.framework '
          sql << "FROM (VALUES #{values.join(', ')}) AS v(benchmark, framework, id) WHERE r.id = v.id"

          ActiveRecord::Base.connection.execute(sql)
        end
      end
    end
  end
end
