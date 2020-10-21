module FacilitiesManagement
  module Procurements
    class ContractsController < FacilitiesManagement::FrameworkController
      include FacilitiesManagement::ControllerLayoutHelper
      include FacilitiesManagement::Procurements::ContractsHelper

      before_action :set_procurement
      before_action :set_contract
      before_action :authorize_user
      before_action :redirect_if_contract_cannot_be_updated, only: %i[edit update]
      before_action :set_page_detail, only: %i[show edit]
      before_action :assign_contract_attributes, only: :update

      def show; end

      def edit
        redirect_to_last_contract_closed_page if params[:name] == 'next_supplier' && @procurement.unsent_direct_award_offers.empty?
      end

      def update
        case params[:name]
        when 'withdraw'
          close_procurement
        when 'signed'
          update_supplier_response
        when 'next_supplier'
          if @contract.last_offer?
            no_more_suppliers
          else
            send_offer_to_next_supplier
          end
        end
      end

      private

      def set_procurement
        @procurement = Procurement.find(params[:procurement_id])
      end

      def set_contract
        @contract = ProcurementSupplier.find(params[:id])
      end

      def redirect_if_contract_cannot_be_updated
        redirect_to facilities_management_procurement_contract_path if cannot_edit_or_update_contract?
      end

      def cannot_edit_or_update_contract?
        if @contract.closed?
          true
        else
          case params[:name]
          when 'next_supplier'
            @contract.cannot_offer_to_next_supplier?
          when 'withdraw'
            @contract.cannot_withdraw?
          when 'signed'
            !@contract.accepted?
          end
        end
      end

      def assign_contract_attributes
        return if params[:name] == 'next_supplier'

        @contract.assign_attributes(contract_params)
      end

      def close_procurement
        if @contract.valid?(:reason_for_closing)
          @contract.save!
          @contract.withdraw! if @contract.may_withdraw?
          @procurement.set_state_to_closed!
          redirect_to facilities_management_procurement_contract_closed_index_path(@procurement.id, contract_id: @contract.id)
        else
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
        next_contract = @procurement.unsent_direct_award_offers.first
        @procurement.offer_to_next_supplier
        @procurement.save
        redirect_to facilities_management_procurement_contract_sent_index_path(@procurement.id, contract_id: next_contract.id)
      end

      def redirect_to_last_contract_closed_page
        last_contract = @procurement.procurement_suppliers.where(direct_award_value: Procurement::DIRECT_AWARD_VALUE_RANGE).last
        redirect_to facilities_management_procurement_contract_sent_index_path(@procurement.id, contract_id: last_contract.id)
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

      protected

      def authorize_user
        authorize! :manage, @procurement
      end
    end
  end
end
