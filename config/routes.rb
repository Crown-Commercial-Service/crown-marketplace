# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  get '/', to: 'home#index'
  get '/status', to: 'home#status'
  get '/cookies', to: 'home#cookies'
  get '/landing-page', to: 'home#landing_page'

  namespace 'supply_teachers', path: 'supply-teachers' do
    get '/', to: 'home#index'
    get '/cognito', to: 'gateway#index', cognito_enabled: true
    get '/gateway', to: 'gateway#index'
    get '/temp-to-perm-fee', to: 'home#temp_to_perm_fee'
    get '/master-vendors', to: 'suppliers#master_vendors', as: 'master_vendors'
    get '/neutral-vendors', to: 'suppliers#neutral_vendors', as: 'neutral_vendors'
    get '/all-suppliers', to: 'suppliers#all_suppliers', as: 'all_suppliers'
    get '/agency-payroll-results', to: 'branches#index', slug: 'agency-payroll-results'
    get '/fixed-term-results', to: 'branches#index', slug: 'fixed-term-results', as: 'fixed_term_results'
    get '/nominated-worker-results', to: 'branches#index', slug: 'nominated-worker-results'
    resources :branches, only: %i[index show]
    resources :downloads, only: :index
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'facilities_management', path: 'facilities-management' do
    get '/', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    get '/value-band', to: 'select_locations#select_location'
    get '/select-locations', to: 'select_locations#select_location', as: 'select_FM_locations'
    get '/select-services', to: 'select_services#select_services', as: 'select_FM_services'
    get '/suppliers/long-list', to: 'long_list#long_list'
    post '/suppliers/longList' => 'long_list#long_list'
    get '/standard-contract/questions', to: 'standard_contract_questions#standard_contract_questions'
    get '/buildings-list', to: 'buildings#buildings'
    get '/buildings/new-building', to: 'buildings#new_building'
    get '/suppliers', to: 'suppliers#index'
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'management_consultancy', path: 'management-consultancy' do
    get '/', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    get '/suppliers', to: 'suppliers#index'
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'apprenticeships', path: 'apprenticeships' do
    get '/', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    get '/search', to: 'home#search'
    get '/search_results', to: 'home#search_results'
    get '/supplier_search', to: 'home#supplier_search'
    get '/supplier_search2', to: 'home#supplier_search2'
    get '/find_apprentices', to: 'home#find_apprentices'
    get '/find_apprentices2', to: 'home#find_apprentices2'
    get '/find_apprentices3', to: 'home#find_apprentices3'
    get '/find_apprentices4', to: 'home#find_apprentices4'
    get '/find_apprentices5', to: 'home#find_apprentices5'
    get '/outline', to: 'home#outline'
    get '/requirements', to: 'home#requirements'
    get '/requirement', to: 'home#requirement'
    get '/building_services', to: 'home#building_services'
    get '/training_provider', to: 'home#training_provider'
    get '/training_provider_list', to: 'home#training_provider_list'
    get '/sorry', to: 'home#sorry'
    get '/signup', to: 'home#signup'
    get '/understanding', to: 'home#understanding'
    get '/training_details', to: 'home#training_details'
  end

  get '/errors/404'
  get '/errors/422'
  get '/errors/500'
  get '/errors/maintenance'

  get '/auth/cognito', as: :cognito_sign_in
  get '/auth/cognito/callback' => 'auth#callback'
  if Marketplace.dfe_signin_enabled?
    get '/auth/dfe', as: :dfe_sign_in
    get '/auth/dfe/callback' => 'auth#callback'
  end
  post '/sign-out' => 'auth#sign_out', as: :sign_out

  get '/:journey/start', to: 'journey#start', as: 'journey_start'
  get '/:journey/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
# rubocop:enable Metrics/BlockLength
