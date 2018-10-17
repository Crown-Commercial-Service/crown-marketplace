require 'rails_helper'

RSpec.describe BranchesController, type: :controller do
  describe 'GET index' do
    context 'with a valid postcode' do
      let(:postcode) { 'W1A 1AA' }
      let(:branches) { %i[first_branch second_branch] }
      let(:request_params) do
        { postcode: postcode,
          nominated_worker: 'yes',
          hire_via_agency: 'yes' }
      end

      before do
        allow(Branch).to receive(:search).and_return(branches)

        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => [51.5149666, -0.119098] }]
        )
        get :index, params: request_params
      end

      it 'assigns back_path to postcode search path' do
        expect(assigns(:back_path)).to eq(school_postcode_question_path(request_params))
      end

      it 'assigns branches to @branches' do
        expect(assigns(:branches)).to eq(branches)
      end

      it 'responds to html' do
        expect(response.content_type).to eq 'text/html'
      end

      it 'responds to requests for spreadsheets' do
        allow(Spreadsheet).to receive(:new).and_return(instance_double('Spreadsheet', to_xlsx: 'spreadsheet-data'))

        get :index, params: request_params.merge(format: 'xlsx')

        expect(response.content_type).to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
    end

    context 'when postcode is missing' do
      let(:branches) { %i[first_branch second_branch] }

      before do
        allow(Branch).to receive(:all).and_return(branches)
        allow(Branch).to receive(:includes).and_return(Branch)
      end

      it 'assigns all branches to @branches' do
        get :index
        expect(assigns(:branches)).to eq(branches)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end

      it 'responds to html' do
        get :index
        expect(response.content_type).to eq 'text/html'
      end

      it 'responds to requests for spreadsheets' do
        allow(Spreadsheet).to receive(:new).and_return(instance_double('Spreadsheet', to_xlsx: 'spreadsheet-data'))

        get :index, params: { format: 'xlsx' }

        expect(response.content_type).to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
    end

    context 'when postcode parsing fails' do
      before do
        get :index, params: {
          postcode: 'nonsense',
          nominated_worker: 'yes',
          hire_via_agency: 'yes'
        }
      end

      it 'redirects to school postcode question' do
        expect(response).to redirect_to(
          school_postcode_question_path(
            postcode: 'nonsense',
            nominated_worker: 'yes',
            hire_via_agency: 'yes'
          )
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Postcode is invalid'
      end
    end

    context 'when postcode geocoding fails' do
      let(:postcode) { valid_fake_postcode }

      before do
        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => nil }]
        )
        get :index, params: {
          postcode: postcode,
          nominated_worker: 'yes',
          hire_via_agency: 'yes'
        }
      end

      it 'redirects to school postcode question' do
        expect(response).to redirect_to(
          school_postcode_question_path(
            postcode: postcode,
            nominated_worker: 'yes',
            hire_via_agency: 'yes'
          )
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq "Couldn't find that postcode"
      end
    end
  end
end
