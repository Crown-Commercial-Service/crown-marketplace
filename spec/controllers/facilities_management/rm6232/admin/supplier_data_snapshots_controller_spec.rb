require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierDataSnapshotsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }

  login_fm_admin

  describe 'GET #new' do
    context 'when logged in as an fm admin' do
      it 'renders the new' do
        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when not logged in as an fm admin' do
      login_fm_buyer

      it 'redirects to not permitted page' do
        get :new

        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end
  end

  describe 'POST create' do
    let(:snapshot_generator) { instance_double(FacilitiesManagement::RM6232::Admin::SupplierDataSnapshotGenerator) }
    let(:fake_zip_file) { Tempfile.new(['supplier_data', '.zip']) }
    let(:create_params) { { snapshot_date_yyyy: snapshot_date_time.year.to_s, snapshot_date_mm: snapshot_date_time.month.to_s, snapshot_date_dd: snapshot_date_time.day.to_s, snapshot_time_hh: '', snapshot_time_mm: '' } }
    let(:valid) { true }

    before do
      FacilitiesManagement::RM6232::Admin::SupplierData.latest_data.update(created_at: snapshot_date_time - 1.day)
      allow(FacilitiesManagement::RM6232::Admin::SupplierDataSnapshotGenerator).to receive(:new).and_return(snapshot_generator)
      allow(snapshot_generator).to receive(:build_zip_file)
      allow(snapshot_generator).to receive(:to_zip).and_return(fake_zip_file)

      post :create, params: { facilities_management_rm6232_admin_supplier_data_snapshot: create_params }
    end

    after { fake_zip_file.unlink }

    context 'when the data is valid in BST' do
      let(:snapshot_date_time) { Time.find_zone('London').local(2022, 11, 11) }

      it 'download the zip with the right filename' do
        expect(response.headers['Content-Disposition']).to include "filename=\"Supplier data spreadsheets %28#{format('%02d', snapshot_date_time.day)}_#{format('%02d', snapshot_date_time.month)}_#{snapshot_date_time.year}%29.zip\""
        expect(response.headers['Content-Type']).to eq 'application/zip'
      end
    end

    context 'when the data is valid in GMT' do
      let(:snapshot_date_time) { Time.find_zone('London').local(2022, 7, 7) }

      it 'download the zip with the right filename' do
        expect(response.headers['Content-Disposition']).to include "filename=\"Supplier data spreadsheets %28#{format('%02d', snapshot_date_time.day)}_#{format('%02d', snapshot_date_time.month)}_#{snapshot_date_time.year}%29.zip\""
        expect(response.headers['Content-Type']).to eq 'application/zip'
      end
    end

    context 'when the data is invliad' do
      let(:snapshot_date_time) { 1.day.from_now }
      let(:create_params) { { snapshot_date_yyyy: '', snapshot_date_mm: '', snapshot_date_dd: '', snapshot_time_hh: '', snapshot_time_mm: '' } }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end
end
