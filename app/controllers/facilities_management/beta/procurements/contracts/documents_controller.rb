module FacilitiesManagement
  module Beta
    module Procurements
      module Contracts
        class DocumentsController < FacilitiesManagement::Beta::FrameworkController
          def call_off_schedule
            @contract = FacilitiesManagement::ProcurementSupplier.find(params[:contract_id])
            @supplier = @contract.supplier
            @procurement = @contract.procurement
            @buyer_detail = @procurement.user.buyer_detail
            @supplier_detail = FacilitiesManagement::SupplierDetail.find_by(contact_email: @supplier.data['contact_email'])
            @invoice_contact_detail = @procurement.using_buyer_detail_for_invoice_details? ? @buyer_detail : @procurement.invoice_contact_detail
            @authorised_contact_detail = @procurement.using_buyer_detail_for_invoice_details? ? @buyer_detail : @procurement.authorised_contact_detail
            @notice_contact_detail = @procurement.using_buyer_detail_for_notices_detail? ? @buyer_detail : @procurement.notices_contact_detail

            respond_to do |format|
              format.docx { headers['Content-Disposition'] = 'attachment; filename="Attachment 4 - Order Form and Call-off Schedule (DA).docx"' }
            end
          end
        end
      end
    end
  end
end
