require 'rails_helper'

RSpec.describe ActiveStorage::BlobsController, type: :controller do
  describe '#show' do
    context 'when signed in' do
      login_fm_buyer_with_details
      let(:contract) { build(:facilities_management_procurement_supplier_da_with_supplier) }
      let(:procurement) { create(:facilities_management_procurement_with_security_document, user: controller.current_user, procurement_suppliers: [contract]) }

      context 'when signed in as the buyer that created the procurement' do
        it 'returns the path' do
          get :show, params: { signed_id: procurement.security_policy_document_file.blob.signed_id, filename: procurement.security_policy_document_file.blob.filename, disposition: 'attachment', contract_id: contract.id }
          expect(response).to have_http_status(:found)
        end
      end

      context 'when signed in as the buyer that created the procurement' do
        it 'returns the path' do
          get :show, params: { signed_id: procurement.security_policy_document_file.blob.signed_id, filename: procurement.security_policy_document_file.blob.filename, disposition: 'attachment', contract_id: contract.id }
          expect(response).to have_http_status(:found)
        end
      end

      context 'when signed in as the supplier that the procurement belongs to' do
        login_fm_supplier
        it 'returns the path' do
          contract.supplier.update(contact_email: controller.current_user.email)

          get :show, params: { signed_id: procurement.security_policy_document_file.blob.signed_id, filename: procurement.security_policy_document_file.blob.filename, disposition: 'attachment', contract_id: contract.id }
          expect(response).to have_http_status(:found)
        end
      end

      context 'when signed in as a different buyer than the one that created the procurement' do
        login_fm_buyer_with_details
        it 'redirects to not permitted page' do
          procurement.update(user: create(:user))
          get :show, params: { signed_id: procurement.security_policy_document_file.blob.signed_id, filename: procurement.security_policy_document_file.blob.filename, disposition: 'attachment', contract_id: contract.id, procurement_id: procurement.id }
          expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
        end
      end

      context 'when procurement_id or contract_id is not passed through' do
        it 'raises not found exception' do
          expect { get :show, params: { signed_id: procurement.security_policy_document_file.blob.signed_id, filename: procurement.security_policy_document_file.blob.filename, disposition: 'attachment' } }.to raise_error('not found')
        end
      end
    end

    context 'when not signed in' do
      let(:contract) { build(:facilities_management_procurement_supplier_da_with_supplier) }
      let(:procurement) { create(:facilities_management_procurement_with_security_document, procurement_suppliers: [contract]) }

      it 'returns :unauthorized' do
        get :show, params: { signed_id: procurement.security_policy_document_file.blob.signed_id, filename: procurement.security_policy_document_file.blob.filename, disposition: 'attachment', contract_id: contract.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
