require 'rails_helper'

RSpec.describe ActiveStorage::Blobs::RedirectController do
  let(:default_params) do
    {
      signed_id: signed_id,
      filename: filename,
      disposition: 'attachment',
      key: object_id_key,
      value: object_id
    }
  end

  # rubocop:disable RSpec/NestedGroups
  describe '#show' do
    context 'when trying to download an RM3830 management report' do
      let(:signed_id) { management_report.management_report_csv.blob.signed_id }
      let(:filename) { management_report.management_report_csv.blob.filename }
      let(:object_id_key) { :rm3830_management_report_id }
      let(:object_id) { management_report.id }
      let(:management_report) { create(:facilities_management_rm3830_admin_management_report_with_report, user: create(:user)) }

      context 'when signed in as a buyer' do
        login_fm_buyer_with_details

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as a supplier' do
        login_fm_supplier

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as an admin' do
        login_fm_admin

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end

        context 'when the key is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:key)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the value is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:value)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the key is not valid' do
          let(:object_id_key) { :fake_procurement_id_key }

          it 'redirects to the not permitted path' do
            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the object does not exist' do
          let(:object_id) { SecureRandom.uuid }

          it 'is raise a routing error' do
            expect { get :show }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      context 'when not signed in' do
        it 'returns unauthorized' do
          get :show

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when trying to download an RM6232 management report' do
      let(:signed_id) { management_report.management_report_csv.blob.signed_id }
      let(:filename) { management_report.management_report_csv.blob.filename }
      let(:object_id_key) { :rm6232_management_report_id }
      let(:object_id) { management_report.id }
      let(:management_report) { create(:facilities_management_rm6232_admin_management_report_with_report, user: create(:user)) }

      context 'when signed in as a buyer' do
        login_fm_buyer_with_details

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as a supplier' do
        login_fm_supplier

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as an admin' do
        login_fm_admin

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end

        context 'when the key is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:key)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the value is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:value)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the key is not valid' do
          let(:object_id_key) { :fake_procurement_id_key }

          it 'redirects to the not permitted path' do
            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the object does not exist' do
          let(:object_id) { SecureRandom.uuid }

          it 'is raise a routing error' do
            expect { get :show }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      context 'when not signed in' do
        it 'returns unauthorized' do
          get :show

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when trying to download an admin upload in RM3830' do
      let(:signed_id) { admin_upload.supplier_data_file.blob.signed_id }
      let(:filename) { admin_upload.supplier_data_file.blob.filename }
      let(:object_id_key) { :rm3830_admin_upload_id }
      let(:object_id) { admin_upload.id }
      let(:admin_upload) { create(:facilities_management_rm3830_admin_upload_with_upload) }

      context 'when signed in as a buyer' do
        login_fm_buyer_with_details

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as a supplier' do
        login_fm_supplier

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as an admin' do
        login_fm_admin

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end

        context 'when the key is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:key)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the value is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:value)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the key is not valid' do
          let(:object_id_key) { :fake_procurement_id_key }

          it 'redirects to the not permitted path' do
            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the object does not exist' do
          let(:object_id) { SecureRandom.uuid }

          it 'is raise a routing error' do
            expect { get :show }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      context 'when not signed in' do
        it 'returns unauthorized' do
          get :show

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when trying to download an admin upload in RM6232' do
      let(:signed_id) { admin_upload.supplier_details_file.blob.signed_id }
      let(:filename) { admin_upload.supplier_details_file.blob.filename }
      let(:object_id_key) { :rm6232_admin_upload_id }
      let(:object_id) { admin_upload.id }
      let(:admin_upload) { create(:facilities_management_rm6232_admin_upload_with_upload) }

      context 'when signed in as a buyer' do
        login_fm_buyer_with_details

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as a supplier' do
        login_fm_supplier

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as an admin' do
        login_fm_admin

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end

        context 'when the key is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:key)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the value is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:value)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the key is not valid' do
          let(:object_id_key) { :fake_procurement_id_key }

          it 'redirects to the not permitted path' do
            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the object does not exist' do
          let(:object_id) { SecureRandom.uuid }

          it 'is raise a routing error' do
            expect { get :show }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      context 'when not signed in' do
        it 'returns unauthorized' do
          get :show

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when trying to download a security policy document' do
      let(:signed_id) { procurement.security_policy_document_file.blob.signed_id }
      let(:filename) { procurement.security_policy_document_file.blob.filename }
      let(:object_id_key) { :procurement_id }
      let(:object_id) { procurement.id }
      let(:procurement) { create(:facilities_management_rm3830_procurement_with_security_document, user: user) }
      let(:user) { create(:user) }

      context 'when signed in as a buyer who created the procurement' do
        login_fm_buyer_with_details

        let(:user) { controller.current_user }

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end

        context 'when the key is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:key)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the value is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:value)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the key is not valid' do
          let(:object_id_key) { :fake_procurement_id_key }

          it 'redirects to the not permitted path' do
            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the object does not exist' do
          let(:object_id) { SecureRandom.uuid }

          it 'is raise a routing error' do
            expect { get :show }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      context 'when signed in as a buyer and they did not create the procurement' do
        login_fm_buyer_with_details

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as a supplier' do
        login_fm_supplier

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as an admin' do
        login_fm_admin

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end
      end

      context 'when not signed in' do
        it 'returns unauthorized' do
          get :show

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when trying to download the contract documents' do
      let(:signed_id) { contract.contract_documents_zip.blob.signed_id }
      let(:filename) { contract.contract_documents_zip.blob.filename }
      let(:object_id_key) { :contract_id }
      let(:object_id) { contract.id }
      let(:contract) { create(:facilities_management_rm3830_procurement_supplier_with_contract_documents) }
      let(:procurement) { create(:facilities_management_rm3830_procurement, user: user) }
      let(:user) { create(:user) }

      context 'when signed in as a buyer who created the procurement' do
        login_fm_buyer_with_details

        let(:user) { controller.current_user }

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end

        context 'when the key is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:key)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the value is not passed' do
          it 'redirects to the not permitted path' do
            default_params.delete(:value)

            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the key is not valid' do
          let(:object_id_key) { :fake_procurement_id_key }

          it 'redirects to the not permitted path' do
            get :show

            expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
          end
        end

        context 'when the object does not exist' do
          let(:object_id) { SecureRandom.uuid }

          it 'is raise a routing error' do
            expect { get :show }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      context 'when signed in as a buyer and they did not create the procurement' do
        login_fm_buyer_with_details

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as a supplier who is part of the contract' do
        login_fm_supplier

        it 'allows the blob to be downloaded' do
          contract.supplier.update(contact_email: controller.current_user.email)

          get :show

          expect(response).to have_http_status(:found)
        end
      end

      context 'when signed in as a supplier who is not part of the contract' do
        login_fm_supplier

        it 'redirects to the not permitted path' do
          get :show

          expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
        end
      end

      context 'when signed in as an admin' do
        login_fm_admin

        it 'allows the blob to be downloaded' do
          get :show

          expect(response).to have_http_status(:found)
        end
      end

      context 'when not signed in' do
        it 'returns unauthorized' do
          get :show

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
