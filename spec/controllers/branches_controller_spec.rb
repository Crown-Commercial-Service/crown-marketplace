require 'rails_helper'

RSpec.describe BranchesController, type: :controller do
  describe 'GET index' do
    let(:first_branch) { build(:branch) }
    let(:second_branch) { build(:branch) }
    let(:branches) { [first_branch, second_branch] }

    context 'with a valid postcode' do
      let(:postcode) { 'W1A 1AA' }
      let(:request_params) do
        { postcode: postcode,
          worker_type: 'nominated',
          looking_for: 'managed_service_provider',
          school_payroll: 'yes' }
      end

      before do
        allow(Branch).to receive(:search).and_return(branches)

        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => [51.5149666, -0.119098] }]
        )
        get :index, params: request_params
      end

      it 'assigns back_path to school-postcode question path' do
        expect(assigns(:back_path)).to eq(
          search_question_path(request_params.merge(slug: 'school-postcode'))
        )
      end

      it 'assigns BranchSearchResults to @branches' do
        expect(assigns(:branches).map(&:class).uniq).to eq([BranchSearchResult])
      end

      it 'expects branches to be assigned to @branches' do
        expect(assigns(:branches).map(&:name)).to eq([first_branch.name, second_branch.name])
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
      before do
        allow(Branch).to receive(:all).and_return(branches)
        allow(Branch).to receive(:includes).and_return(Branch)
      end

      it 'assigns to @branches' do
        get :index
        expect(assigns(:branches).map(&:class).uniq).to eq([BranchSearchResult])
      end

      it 'expects branches to be assigned to @branches' do
        get :index
        expect(assigns(:branches).map(&:name)).to eq([first_branch.name, second_branch.name])
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
      let(:params) do
        {
          postcode: 'nonsense',
          worker_type: 'nominated',
          looking_for: 'worker'
        }
      end

      before do
        get :index, params: params
      end

      it 'redirects to school-postcode question' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-postcode'))
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
          worker_type: 'nominated',
          looking_for: 'worker'
        }
      end

      it 'redirects to school-postcode question' do
        expect(response).to redirect_to(
          search_question_path(
            slug: 'school-postcode',
            postcode: postcode,
            worker_type: 'nominated',
            looking_for: 'worker'
          )
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq "Couldn't find that postcode"
      end
    end
  end
end
