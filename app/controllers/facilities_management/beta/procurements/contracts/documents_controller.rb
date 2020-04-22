module FacilitiesManagement
  module Beta
    module Procurements
      module Contracts
        class DocumentsController < FacilitiesManagement::Beta::FrameworkController
          # If this document generation changes you must change it
          # app/helpers/facilities_management/beta/procurements/documents_procurement_helper.rb self.generate_doc
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

          def zip_contracts
            file_stream = FacilitiesManagement::Beta::Procurements::DocumentsProcurementHelper.build_download_zip_file(params[:procurement_id])
            send_data file_stream.read, filename: 'review_your_contract.zip', type: 'application/zip'
          end

          def download_zip_contracts
            @procurement = FacilitiesManagement::Procurement.find(params[:procurement_id])
            send_data @procurement.contract_documents_zip.download, filename: 'review_your_contract.zip', type: 'application/zip'
          end
        end
      end
    end
  end
end
