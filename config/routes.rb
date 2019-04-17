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
    get '/fta-to-perm-fee', to: 'home#fta_to_perm_fee'
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
    get '/buildings/new-building-address', to: 'buildings#manual_address_entry_form'
    post '/buildings/new-building-address/save-building' => 'buildings#save_building'
    get '/buildings/building-type', to: 'buildings#building_type'
    post '/buildings/update_building' => 'buildings#update_building'
    get '/buildings/select-services', to: 'buildings#select_services_per_building'

    get '/summary', to: 'summary#index'

    get '/buildings/units-of-measurement', to: 'buildings#units_of_measurement'
    post '/buildings/save-uom-value' => 'buildings#save_uom_value'
    get '/suppliers', to: 'suppliers#index'

    get '/start', to: 'journey#start', as: 'journey_start'
    get '/contract-start', to: 'contract#start_of_contract'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'management_consultancy', path: 'management-consultancy' do
    get '/', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    get '/suppliers', to: 'suppliers#index'
    get '/suppliers/download', to: 'suppliers#download', as: 'suppliers_download'
    get '/suppliers/:id', to: 'suppliers#show', as: 'supplier'
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
    get '/download_provider', to: 'home#download_provider'
  end

  namespace 'ccs_patterns', path: 'ccs-patterns' do
    get '/', to: 'home#index'
    get '/dynamic-accordian', to: 'home#dynamic_accordian'
    get '/supplier-results-v1', to: 'home#supplier_results_v1'
    get '/supplier-results-v2', to: 'home#supplier_results_v2'
    get '/small-checkboxes', to: 'home#small_checkboxes'
    get '/titles-checkboxes', to: 'home#titles_checkboxes'
    get '/numbered-pagination', to: 'home#numbered_pagination'
    get '/table-5050', to: 'home#table_5050'
    get '/errors-find-apprentices', to: 'home#errors_find_apprentices'
    get '/errors-find-apprentices2', to: 'home#errors_find_apprentices2'
    get '/errors-find-apprentices3', to: 'home#errors_find_apprentices3'
    get '/errors-find-apprentices4', to: 'home#errors_find_apprentices4'
    get '/errors-requirements', to: 'home#errors_requirements'
  end

  namespace 'legal_services', path: 'legal-services' do
    get '/', to: 'home#index'
    get '/service-not-suitable', to: 'home#service_not_suitable'
    get '/suppliers/download_shortlist', to: 'suppliers#download_shortlist'
    resources :suppliers, only: %i[index show]
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
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

  scope module: :postcode do
    resources :postcodes, only: [:show]
  end

  get '/:journey/start', to: 'journey#start', as: 'journey_start'
  get '/:journey/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
# rubocop:enable Metrics/BlockLength
