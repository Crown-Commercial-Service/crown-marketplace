require 'rails_helper'

RSpec.describe SupplyTeachers::BranchesController, type: :controller do
  describe 'GET index' do
    let(:first_branch) { build(:branch) }
    let(:second_branch) { build(:branch) }
    let(:branches) { [first_branch, second_branch] }

    context 'when not logged in' do
      before do
        ensure_not_logged_in
      end

      it 'redirects to gateway page' do
        expect(get(:index)).to redirect_to(gateway_path)
      end
    end

    context 'with a valid postcode' do
      let(:postcode) { 'W1A 1AA' }
      let(:params) do
        {
          journey: 'supply-teachers',
          looking_for: 'worker',
          worker_type: 'nominated',
          postcode: postcode,
          slug: 'nominated-worker-results'
        }
      end

      before do
        allow(SupplyTeachers::Branch).to receive(:search).and_return(branches)

        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => [51.5149666, -0.119098] }]
        )
        get :index, params: params
      end

      after do
        Geocoder::Lookup::Test.reset
      end

      it 'assigns back_path to school-postcode-nominated-worker question path' do
        expect(assigns(:back_path)).to eq(
          journey_question_path(params.merge(slug: 'school-postcode-nominated-worker'))
        )
      end

      it 'assigns BranchSearchResults to @branches' do
        expect(assigns(:branches).map(&:class).uniq).to eq(
          [SupplyTeachers::BranchSearchResult]
        )
      end

      it 'expects branches to be assigned to @branches' do
        expect(assigns(:branches).map(&:name))
          .to eq([first_branch.name, second_branch.name])
      end

      context 'when no radius is specified' do
        it 'assigns radius_in_miles to the default radius' do
          expect(assigns(:radius_in_miles)).to eq(25)
        end
      end

      context 'when a radius is specified' do
        let(:params) { super().merge(radius: '5') }

        it 'assigns radius_in_miles to the given radius' do
          expect(assigns(:radius_in_miles)).to eq(5)
        end
      end

      it 'responds to html' do
        expect(response.content_type).to eq 'text/html'
      end

      it 'responds to requests for spreadsheets' do
        allow(SupplyTeachers::Spreadsheet)
          .to receive(:new)
          .and_return(instance_double('Spreadsheet', to_xlsx: 'spreadsheet-data'))

        get :index, params: params.merge(format: 'xlsx')

        expect(response.content_type)
          .to eq 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
    end

    context 'when postcode parsing fails' do
      let(:params) do
        {
          journey: 'supply-teachers',
          postcode: 'nonsense',
          worker_type: 'nominated',
          looking_for: 'worker'
        }
      end

      before do
        get :index, params: params
      end

      it 'renders school-postcode-nominated-worker question' do
        expect(response).to render_template('journey/school_postcode_nominated_worker')
      end
    end

    context 'when postcode geocoding fails' do
      let(:postcode) { valid_fake_postcode }

      before do
        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => nil }]
        )
        get :index, params: {
          journey: 'supply-teachers',
          postcode: postcode,
          worker_type: 'nominated',
          looking_for: 'worker'
        }
      end

      after do
        Geocoder::Lookup::Test.reset
      end

      it 'renders school-postcode-nominated-worker question' do
        expect(response).to render_template('journey/school_postcode_nominated_worker')
      end
    end
  end
end
