module FacilitiesManagement
  module RM6378
    class ProcurementsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement, only: %i[show]
      before_action :authorize_user
      before_action :set_back_path
      before_action :set_procurements, :set_journey_attributes, only: %i[new create]

      def index
        @searches = current_user.procurements.where(framework_id: 'RM6378').order(updated_at: :asc)
      end

      def show; end

      def new; end

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      def create
        @procurements.each { |procurement| procurement.assign_attributes(procurement_params) }

        if @procurements.first.valid?(:contract_name)
          begin
            @procurements[1].update_contract_name_with_security if @procurements.length > 1

            ActiveRecord::Base.transaction do
              @procurements.each(&:save!)

              flash[:second_procurement_name] = @procurements[1].contract_name if @procurements.length > 1

              redirect_to facilities_management_rm6378_procurement_path(@procurements.first)

              return
            rescue ActiveRecord::Rollback => e
              Rollbar.log('error', e)
              @procurements[0].errors.add(:contract_name, :taken)
            end
          rescue Procurement::CannotCreateNameError
            @procurements[0].errors.add(:contract_name, :taken)
          end
        end

        render :new
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

      private

      def set_back_path
        @back_path, @back_text = case action_name.to_sym
                                 when :new, :create
                                   [helpers.journey_step_url_former(journey_slug: 'annual-contract-value', annual_contract_value: journey_params[:annual_contract_value], region_codes: journey_params[:region_codes], service_codes: journey_params[:service_codes]), t('facilities_management.rm6378.procurements.new.return_to_contract_cost')]
                                 when :index
                                   [facilities_management_rm6378_path, t('facilities_management.shared.procurements.index.return_to_your_account')]
                                 when :show
                                   [facilities_management_rm6378_procurements_path, t('facilities_management.rm6378.procurements.show.return_to_saved_searches')]
                                 end
      end

      def set_procurement
        @procurement = Procurement.find(params[:id] || params[:procurement_id])
      end

      def set_procurements
        @procurements = LotSelector.select_lot_numbers(journey_params[:service_codes], journey_params[:annual_contract_value]).lot_results.map do |lot_result|
          Procurement.build(
            user: current_user,
            framework_id: 'RM6378',
            lot_id: lot_result.lot_id,
            procurement_details: {
              service_ids: lot_result.service_ids,
              jurisdiction_ids: journey_params[:region_codes],
              annual_contract_value: journey_params[:annual_contract_value]
            }
          )
        end
      end

      def set_journey_attributes
        @services = Service.where(id: @procurements.map { |procurement| procurement.procurement_details['service_ids'] }.flatten).order(:category, Arel.sql('SUBSTRING(number FROM 2)::integer'))
        @regions = Jurisdiction.where(id: journey_params[:region_codes]).order(Arel.sql('LENGTH(id)'), Arel.sql('SUBSTRING(id FROM 4)'))
        @annual_contract_value = journey_params[:annual_contract_value]
      end

      def journey_params
        @journey_params ||= begin
          params[:annual_contract_value] = params[:annual_contract_value].to_i

          params.permit(:annual_contract_value, service_codes: [], region_codes: [])
        end
      end

      def procurement_params
        @procurement_params ||= params.expect(facilities_management_rm6378_procurement: %i[contract_name requirements_linked_to_pfi])
      end

      protected

      def authorize_user
        @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
      end
    end
  end
end
