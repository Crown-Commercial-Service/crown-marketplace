module FacilitiesManagement
  module RM3830
    module Procurements
      module Contracts
        class DocumentsGenerator
          def self.review_docs
            base_scope = %i[facilities_management rm3830 procurements contract_details da_journey review]

            @review_your_contract_static_files = [
              I18n.t('attachment_1.file_name', scope: base_scope),
              I18n.t('attachment_2.annex_a.file_name', scope: base_scope),
              I18n.t('attachment_4.core_terms.file_name', scope: base_scope),

              %w[1 3 4 4A 10 13 5 6 7 8 9 24 25].map do |suffix|
                I18n.t("contract_documents.call_off_schedule_#{suffix}.file_name", scope: base_scope)
              end,

              %w[1 10 11 2 3 5 6 7].map do |suffix|
                I18n.t("contract_documents.joint_schedule_#{suffix}.file_name", scope: base_scope)
              end
            ].flatten
          end

          # rubocop:disable Metrics/AbcSize
          # Disabled this rubucop if we were to implement this rubucop validation
          # it would make the code more complicated in this instance
          def self.build_download_zip_file(contract_id)
            @contract = ProcurementSupplier.find(contract_id)
            @procurement = @contract.procurement
            file_policy = @procurement.security_policy_document_file
            files_path = 'public'
            direct_award_spreadsheet = PriceMatrixSpreadsheet.new(@contract.id)
            direct_award_spreadsheet.build
            deliverable_matrix_spreadsheet = DirectAwardDeliverablesMatrix.new(@contract.id)
            deliverable_matrix_spreadsheet.build
            @review_your_contract_static_files = review_docs

            file_stream = Zip::OutputStream.write_buffer do |zip|
              zip.put_next_entry 'Attachment 3 - Price Matrix (DA).xlsx'
              zip.print direct_award_spreadsheet.to_xlsx
              zip.put_next_entry 'Attachment 2 - Statement of Requirements - Deliverables Matrix (DA).xlsx'
              zip.print deliverable_matrix_spreadsheet.to_xlsx

              if @procurement.security_policy_document_file.attached? && @procurement.security_policy_document_required?
                zip.put_next_entry "SEC_POLICY-#{file_policy.blob.filename}"
                zip.print file_policy.download
              end

              @review_your_contract_static_files.each do |file|
                zip.put_next_entry file.split('/').last
                zip.print File.read(Rails.root + files_path + file)
              end

              zip.put_next_entry 'Attachment 4 - Order Form and Call-Off Schedules (DA) v3.0.docx'
              zip.print generate_doc_call_off_schedule(contract_id)

              zip.put_next_entry 'Call-Off Schedule 2 - Staff Transfer (DA) v3.0.docx'
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
          def self.generate_doc_call_off_schedule(contract_id)
            @contract = ProcurementSupplier.find(contract_id)
            @supplier = @contract.supplier
            @procurement = @contract.procurement
            @buyer_detail = @procurement.user.buyer_detail
            @invoice_contact_detail = @procurement.using_buyer_detail_for_invoice_details? ? @buyer_detail : @procurement.invoice_contact_detail
            @authorised_contact_detail = @procurement.using_buyer_detail_for_authorised_detail? ? @buyer_detail : @procurement.authorised_contact_detail
            @notice_contact_detail = @procurement.using_buyer_detail_for_notices_detail? ? @buyer_detail : @procurement.notices_contact_detail

            view_assignement = {
              contract: @contract,
              supplier: @supplier,
              procurement: @procurement,
              buyer_detail: @buyer_detail,
              invoice_contact_detail: @invoice_contact_detail,
              authorised_contact_detail: @authorised_contact_detail,
              notice_contact_detail: @notice_contact_detail
            }

            view = ActionView::Base.new(ActionController::Base.view_paths, {})
            view.assign(view_assignement)
            view.class_eval { include FacilitiesManagement::ContractDatesHelper }
            view.render(file: 'facilities_management/rm3830/procurements/contracts/documents/call_off_schedule.docx.caracal')
          end

          # this document generation relies on
          # app/controllers/facilities_management/beta/procurements/contracts/documents_controller.rb def call_off_schedule_2
          # if that changes this should also change
          # due to the way caracal generates docs we need to use ActionView::Base
          def self.generate_doc_call_off_schedule_2(contract_id)
            @contract = ProcurementSupplier.find(contract_id)
            @procurement = @contract.procurement
            @pension_funds = @procurement.procurement_pension_funds

            view_assignement = {
              contract: @contract,
              procurement: @procurement,
              pension_funds: @pension_funds
            }

            view = ActionView::Base.new(ActionController::Base.view_paths, {})
            view.assign(view_assignement)
            view.render(file: 'facilities_management/rm3830/procurements/contracts/documents/call_off_schedule_2.docx.caracal')
          end

          def self.generate_final_zip(contract_id)
            @contract = ProcurementSupplier.find(contract_id)
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
  end
end
