module FacilitiesManagement
  module Procurements
    class ContractsController < FacilitiesManagement::FrameworkController
      include FacilitiesManagement::ControllerLayoutHelper
      include FacilitiesManagement::Procurements::ContractsHelper

      before_action :set_procurement
      before_action :set_contract
      before_action :authorize_user
      before_action :set_page_detail, only: %i[show edit]
      before_action :assign_contract_attributes, only: :update

      def show; end

      def edit; end

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def update
        close_procurement && return if params['close_procurement'].present?
        update_supplier_response && return if params['sign_procurement'].present?
        no_more_suppliers && return if @contract.last_offer?
        send_offer_to_next_supplier && return if params['send_contract_to_next_supplier'].present?
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      private

      def set_procurement
        @procurement = Procurement.find(params[:procurement_id])
      end

      def set_contract
        @contract = ProcurementSupplier.find(params[:id])
      end

      def assign_contract_attributes
        return if params['send_contract_to_next_supplier'].present?

        @contract.assign_attributes(contract_params)
      end

      def close_procurement
        if @contract.valid?(:reason_for_closing)
          @contract.save!
          @contract.withdraw! if @contract.may_withdraw?
          @procurement.set_state_to_closed!
          redirect_to facilities_management_procurement_contract_closed_index_path(@procurement.id, contract_id: @contract.id)
        else
          params[:name] = 'withdraw'
          set_page_detail
          render :edit
        end
      end

      def update_supplier_response
        if @contract.valid?(:confirmation_of_signed_contract)
          if @contract.contract_signed
            @contract.sign!
            redirect_to facilities_management_procurement_contract_closed_index_path(@procurement.id, contract_id: @contract.id)
          else
            @contract.not_sign!
            redirect_to facilities_management_procurement_contract_path(@procurement.id, contract_id: @contract.id)
          end
        else
          set_page_detail
          render :edit
        end
      end

      def send_offer_to_next_supplier
        next_contract = @procurement.procurement_suppliers.unsent.where(direct_award_value: 0..0.15e7).first
        @procurement.offer_to_next_supplier
        @procurement.save
        redirect_to facilities_management_procurement_contract_sent_index_path(@procurement.id, contract_id: next_contract.id)
      end

      def no_more_suppliers
        @procurement.set_state_to_closed!
        redirect_to facilities_management_procurement_contract_sent_index_path(@procurement.id, contract_id: @contract.id)
      end

      def contract_params
        params.require(:facilities_management_procurement_supplier)
              .permit(
                :reason_for_closing,
                :contract_signed,
                :reason_for_not_signing,
                :contract_start_date_dd,
                :contract_start_date_mm,
                :contract_start_date_yyyy,
                :contract_end_date_dd,
                :contract_end_date_mm,
                :contract_end_date_yyyy
              )
      end

      def authorize_user
        authorize! :manage, @procurement
      end
    end
  end
end
