module FacilitiesManagement
  module Procurements
    class DocumentsProcurementHelper
      def self.review_docs
        @review_your_contract_static_files = [
          'About the Direct Award.docx',
          'Statement of Requirements - Annex A - Standards and Processes.docx',
          'Core Terms v3.0.2 (DA).docx',
          'Call-Off Schedule 1 Transparency Reports (DA).docx',
          'Call-Off Schedule 3 - Continuous Improvement (DA).docx',
          'Call-Off Schedule 4 - Facilities Management (DA).docx',
          'Call-Off Schedule 4A - Billable Works and Projects (DA).docx',
          'Call-Off Schedule 10 - Exit Management (DA).docx',
          'Call-Off Schedule 13 - Mobilisation Plan and Testing (DA).docx',
          'Call-Off Schedule 5 - Call-Off Pricing (DA).docx',
          'Call-Off Schedule 6 - TUPE Surcharge (DA).docx',
          'Call-Off Schedule 7 - Key Staff (DA).docx',
          'Call-Off Schedule 8 - Business Continuity and Disaster Recovery (DA).docx',
          'Call-Off Schedule 9 - Security (DA).docx',
          'Joint Schedule 1 - Definitions (DA).docx',
          'Joint Schedule 10 - Rectification Plan (DA).docx',
          'Joint Schedule 11 - Processing Data (DA).docx',
          'Joint Schedule 2 - Variation Form (DA).docx',
          'Joint Schedule 3 - Insurance Requirements (DA).docx',
          'Joint Schedule 5 - Corporate Social Responsibility (DA).docx',
          'Joint Schedule 6 - Key Subcontractors (DA).docx',
          'Joint Schedule 7 - Financial Distress (DA).docx'
        ]
      end

      # rubocop:disable Metrics/AbcSize
      # Disabled this rubucop if we were to implement this rubucop validation
      # it would make the code more complicated in this instance
      def self.build_download_zip_file(contract_id)
        @contract = FacilitiesManagement::ProcurementSupplier.find(contract_id)
        @procurement = @contract.procurement
        file_policy = @procurement.security_policy_document_file
        files_path = 'app/assets/files/'
        direct_award_spreadsheet = FacilitiesManagement::DirectAwardSpreadsheet.new @contract.id
        deliverable_matrix_spreadsheet = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new @contract.id
        deliverable_matrix_spreadsheet_built = deliverable_matrix_spreadsheet.build
        @review_your_contract_static_files = FacilitiesManagement::Procurements::DocumentsProcurementHelper.review_docs

        file_stream = Zip::OutputStream.write_buffer do |zip|
          zip.put_next_entry 'direct_award_prices.xlsx'
          zip.print direct_award_spreadsheet.to_xlsx
          zip.put_next_entry 'deliverable_matrix.xlsx'
          zip.print deliverable_matrix_spreadsheet_built.to_stream.read

          if @procurement.security_policy_document_file.attached? && @procurement.security_policy_document_required?
            zip.put_next_entry 'SEC_POLICY-' + file_policy.blob.filename.to_s
            zip.print file_policy.download
          end

          @review_your_contract_static_files.each do |file|
            zip.put_next_entry file
            zip.print IO.read(Rails.root + files_path + file)
          end

          zip.put_next_entry 'Attachment 4 - Order Form and Call-off Schedule (DA).docx'
          zip.print generate_doc(contract_id)

          zip.put_next_entry 'Call-Off Schedule 2 - Staff Transfer (DA).docx'
          zip.print generate_doc_call_off_schedule_2(contract_id)
        end

        file_stream.rewind
        file_stream
      end
      # rubocop:enable Metrics/AbcSize

      # this document generation relies on
      # app/controllers/facilities_management/beta/procurements/contracts/documents_controller.rb def call_off_schedule
      # if that changes this should also change
      # due to the way caracal generates docs we need to use ActionView::Base
      def self.generate_doc(contract_id)
        @contract = FacilitiesManagement::ProcurementSupplier.find(contract_id)
        @supplier = @contract.supplier
        @procurement = @contract.procurement
        @buyer_detail = @procurement.user.buyer_detail
        @supplier_detail = FacilitiesManagement::SupplierDetail.find_by(contact_email: @supplier.data['contact_email'])
        @invoice_contact_detail = @procurement.using_buyer_detail_for_invoice_details? ? @buyer_detail : @procurement.invoice_contact_detail
        @authorised_contact_detail = @procurement.using_buyer_detail_for_authorised_detail? ? @buyer_detail : @procurement.authorised_contact_detail
        @notice_contact_detail = @procurement.using_buyer_detail_for_notices_detail? ? @buyer_detail : @procurement.notices_contact_detail

        view_assignement = {
          contract: @contract,
          supplier: @supplier,
          procurement: @procurement,
          buyer_detail: @buyer_detail,
          supplier_detail: @supplier_detail,
          invoice_contact_detail: @invoice_contact_detail,
          authorised_contact_detail: @authorised_contact_detail,
          notice_contact_detail: @notice_contact_detail
        }

        view = ActionView::Base.new(ActionController::Base.view_paths, {})
        view.assign(view_assignement)
        view.render(file: 'facilities_management/procurements/contracts/documents/call_off_schedule.docx.caracal')
      end

      # this document generation relies on
      # app/controllers/facilities_management/beta/procurements/contracts/documents_controller.rb def call_off_schedule_2
      # if that changes this should also change
      # due to the way caracal generates docs we need to use ActionView::Base
      def self.generate_doc_call_off_schedule_2(contract_id)
        @contract = FacilitiesManagement::ProcurementSupplier.find(contract_id)
        @procurement = @contract.procurement
        @pension_funds = @procurement.procurement_pension_funds

        view_assignement = {
          contract: @contract,
          procurement: @procurement,
          pension_funds: @pension_funds
        }

        view = ActionView::Base.new(ActionController::Base.view_paths, {})
        view.assign(view_assignement)
        view.render(file: 'facilities_management/procurements/contracts/documents/call_off_schedule_2.docx.caracal')
      end

      def self.generate_final_zip(contract_id)
        @contract = FacilitiesManagement::ProcurementSupplier.find(contract_id)
        @procurement = @contract.procurement
        file_stream = build_download_zip_file(contract_id)
        @contract.contract_documents_zip.attach(
          io: StringIO.new(file_stream.read),
          filename: 'call-off-contract-documents.zip',
          content_type: 'application/zip'
        )
        @contract.contract_documents_zip_generated = true
        @contract.save
        @contract
      end
    end
  end
end
