require 'rails_helper'

RSpec.describe CrownMarketplace::AllowListController, type: :controller do
  let(:default_params) { { service: 'crown_marketplace' } }
  let(:email_list) { ['cheemail.com', 'cmail.com', 'crowncommercial.gov.uk', 'email.com', 'jmail.com', 'kmail.com', 'tmail.com'] }
  let(:allow_list_file) { Tempfile.new('allow_list.txt') }

  before do
    allow_list_file.write(email_list.join("\n"))
    allow_list_file.close
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(AllowedEmailDomain).to receive(:allow_list_file_path).and_return(allow_list_file.path)
    # rubocop:enable RSpec/AnyInstance
  end

  after do
    allow_list_file.unlink
  end

  describe 'GET index' do
    context 'when not logged in with allow list access' do
      login_fm_admin

      it 'redirects to the not permited path' do
        get :index

        expect(response).to redirect_to not_permitted_url(service: 'crown_marketplace')
      end
    end

    context 'when logged in with allow list access' do
      login_crown_marketplcae_admin

      it 'renders the index page' do
        get :index

        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET new' do
    login_crown_marketplcae_admin

    it 'renders the new page' do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    login_crown_marketplcae_admin

    before { post :create, params: { allowed_email_domain: { email_domain: email_domain } } }

    context 'when the email domain is not valid' do
      let(:email_domain) { 'Go Beyond Plus ULTRA!!!' }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end

    context 'when the email domain is valid' do
      let(:email_domain) { 'email-domain.com' }

      it 'redirects to the index page' do
        expect(response).to redirect_to crown_marketplace_allow_list_index_path(email_domain_added: email_domain)
      end
    end
  end

  describe 'GET search_allow_list' do
    login_crown_marketplcae_admin

    before { get :search_allow_list, params: { allowed_email_domain: { email_domain: 'email' } }, xhr: true }

    it 'renders the search_allow_list page' do
      expect(response).to render_template(:search_allow_list)
    end

    it 'has a shortened allow list' do
      expect(assigns(:paginated_allow_list)).to eq ['cheemail.com', 'email.com']
    end
  end

  describe 'GET delete' do
    login_crown_marketplcae_admin

    it 'renders the delete page' do
      get :delete, params: { email_domain: 'email' }

      expect(response).to render_template(:delete)
    end
  end

  describe 'DESTROY destroy' do
    login_crown_marketplcae_admin

    it 'redirects to the allow list page' do
      delete :destroy, params: { allowed_email_domain: { email_domain: 'email.com' } }

      expect(response).to redirect_to crown_marketplace_allow_list_index_path(email_domain_removed: 'email.com')
    end
  end
end
