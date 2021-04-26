require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurements::SpreadsheetImports::ProgressController, type: :controller do
  let(:default_params) { { service: 'facilities_management' } }
  let(:spreadsheet_import) { create(:facilities_management_procurement_spreadsheet_import, procurement: procurement) }
  let(:procurement) { create(:facilities_management_procurement, aasm_state: 'detailed_search_bulk_upload', user: subject.current_user) }
  let(:user) { subject.current_user }
  let(:wrong_user) { create(:user) }

  login_fm_buyer_with_details

  describe 'GET index' do
    let(:result) { JSON.parse(response.body) }
    let(:other_spreadsheet_import) { create(:facilities_management_procurement_spreadsheet_import, procurement: other_procurement) }
    let(:other_procurement) { create(:facilities_management_procurement, aasm_state: 'detailed_search_bulk_upload', user: other_user) }
    let(:other_user) { create(:user) }

    context 'when the user is not authorised' do
      before { get :index, params: { spreadsheet_import_id: other_spreadsheet_import.id, procurement_id: other_procurement.id } }

      it 'returns false for continue' do
        expect(result['continue']).to be false
      end

      it 'returns false for refresh' do
        expect(result['refresh']).to be false
      end
    end

    context 'when the spreadsheet_import no longer exists' do
      before do
        spreadsheet_import.destroy
        get :index, params: { spreadsheet_import_id: spreadsheet_import.id, procurement_id: procurement.id }
      end

      it 'returns false for continue' do
        expect(result['continue']).to be false
      end

      it 'returns false for refresh' do
        expect(result['refresh']).to be false
      end
    end

    context 'when the user can view the spreadsheet' do
      before do
        spreadsheet_import.update(aasm_state: state)
        get :index, params: { spreadsheet_import_id: spreadsheet_import.id, procurement_id: procurement.id }
      end

      context 'when the spreadsheet is importing' do
        let(:state) { 'importing' }

        it 'returns true for continue' do
          expect(result['continue']).to be true
        end

        it 'returns false for refresh' do
          expect(result['refresh']).to be false
        end
      end

      context 'when the spreadsheet import has succeeded' do
        let(:state) { 'succeeded' }

        it 'returns true for continue' do
          expect(result['continue']).to be true
        end

        it 'returns true for refresh' do
          expect(result['refresh']).to be true
        end
      end

      context 'when the spreadsheet import has failed' do
        let(:state) { 'failed' }

        it 'returns true for continue' do
          expect(result['continue']).to be true
        end

        it 'returns true for refresh' do
          expect(result['refresh']).to be true
        end
      end
    end
  end
end
