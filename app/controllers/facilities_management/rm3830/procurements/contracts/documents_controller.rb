module FacilitiesManagement
  module RM3830
    module Procurements
      module Contracts
        class DocumentsController < FacilitiesManagement::FrameworkController
          before_action :set_contract, except: :zip_contracts
          # If this document generation changes you must change it
          # app/services/facilities_management/rm3830/procurements/contracts/documents_generator.rb self.call_off_schedule
          def call_off_schedule
            file_stream = DocumentsGenerator.generate_doc_call_off_schedule(params[:contract_id])
            send_data file_stream, filename: 'Attachment 4 - Order Form and Call-Off Schedules (DA) v3.0.docx', type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
          end

          def zip_contracts
            file_stream = DocumentsGenerator.build_download_zip_file(params[:contract_id])
            send_data file_stream.read, filename: 'review_your_contract.zip', type: 'application/zip'
          end

          def call_off_schedule_2
            file_stream = DocumentsGenerator.generate_doc_call_off_schedule_2(params[:contract_id])
            send_data file_stream, filename: 'Call-Off Schedule 2 - Staff Transfer (DA) v3.0.docx', type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
          end

          private

          def set_contract
            @contract = ProcurementSupplier.find(params[:contract_id])
          end

          protected

          def authorize_user
            @contract ||= ProcurementSupplier.find(params[:contract_id])
            authorize! :manage, @contract.procurement
          end
        end
      end
    end
  end
end
