# rubocop:disable Metrics/BlockLength
require 'sidekiq/web'
Rails.application.routes.draw do
  get '/', to: 'home#index'
  get '/status', to: 'home#status'
  get '/cookies', to: 'home#cookies'
  get '/facilities-management/accessibility-statement', to: 'home#accessibility_statement_fm'
  get '/management-consultancy/accessibility-statement', to: 'home#accessibility_statement_mc'
  get '/landing-page', to: 'home#landing_page'
  get '/not-permitted', to: 'home#not_permitted'

  authenticate :user, ->(u) { u.has_role? :ccs_employee } do
    mount Sidekiq::Web => '/sidekiq-log'
  end

  devise_for :users, skip: %i[registrations passwords sessions]
  devise_scope :user do
    concern :authenticatable do
      get '/sign-in', to: 'sessions#new', as: :new_user_session
      post '/sign-in', to: 'sessions#create', as: :user_session
      delete '/sign-out', to: 'sessions#destroy', as: :destroy_user_session
      get '/users/forgot-password', to: 'passwords#new', as: :new_user_password
      post '/users/password', to: 'passwords#create'
      get '/users/forgot-password-confirmation', to: 'passwords#confirm_new', as: :confirm_new_user_password
      get '/users/password', to: 'passwords#edit', as: :edit_user_password
      put '/users/password', to: 'passwords#update'
      get '/users/password-reset-success', to: 'passwords#password_reset_success', as: :password_reset_success
      get '/users/confirm', to: 'users#confirm_new'
      post '/users/confirm', to: 'users#confirm'
      get '/users/challenge', to: 'users#challenge_new'
      post '/users/challenge', to: 'users#challenge'
      get '/resend_confirmation_email', to: 'users#resend_confirmation_email', as: :resend_confirmation_email
    end
    concern :registrable do
      get '/sign-up', to: 'registrations#new', as: :new_user_registration
      post '/sign-up', to: 'registrations#create', as: :user_registration
      get '/domain-not-on-safelist', to: 'registrations#domain_not_on_safelist', as: :domain_not_on_safelist
    end

    delete '/sign-out', to: 'base/sessions#destroy', as: :destroy_user_session

    namespace 'supply_teachers', path: 'supply-teachers' do
      concerns :authenticatable
      namespace :admin do
        concerns :authenticatable
      end
    end

    namespace 'facilities_management', path: 'facilities-management' do
      concerns %i[authenticatable registrable]
      namespace :supplier do
        concerns :authenticatable
      end
      namespace :admin do
        concerns :authenticatable
      end
    end

    namespace 'management_consultancy', path: 'management-consultancy' do
      concerns %i[authenticatable registrable]
      namespace :admin do
        concerns :authenticatable
      end
    end

    namespace 'legal_services', path: 'legal-services' do
      concerns %i[authenticatable registrable]
      namespace :admin do
        concerns :authenticatable
      end
    end
  end

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
    namespace :admin do
      resources :uploads, only: %i[index new create show destroy] do
        get 'approve'
        get 'reject'
        get 'uploading'
        delete 'destroy'
      end
      get '/in_progress', to: 'uploads#in_progress'
    end
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'facilities_management', path: 'facilities-management' do
    get '/', to: 'buyer_account#buyer_account'
    get '/start', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    get '/gateway/validate/:id', to: 'gateway#validate'
    get '/buyer_account', to: 'buyer_account#buyer_account'
    resources :buildings do
      member do
        get 'gia'
        get 'type'
        get 'security'
        match 'add_address', via: %i[get post patch]
      end
    end
    get '/service-specification/:service_code/:work_package_code', to: 'service_specification#show', as: 'service_specification'
    match 'select-services', to: 'select_services#select_services', as: 'select_FM_services', via: %i[get post]
    match '/select-locations', to: 'select_locations#select_location', as: 'select_FM_locations', via: %i[get post]
    match '/summary', to: 'summary#index', via: %i[get post]
    post '/summary/guidance', to: 'summary#guidance'
    post '/summary/suppliers', to: 'summary#sorted_suppliers'
    get 'spreadsheet-test', to: 'spreadsheet_test#index', as: 'spreadsheet_test'
    get 'spreadsheet-test/dm-spreadsheet-download', to: 'spreadsheet_test#dm_spreadsheet_download', as: 'dm_spreadsheet_download'
    get 'procurements/what-happens-next', as: 'what_happens_next', to: 'procurements#what_happens_next'

    resources :procurements do
      get 'further_competition_spreadsheet'
      post 'da_spreadsheets'
      get '/documents/zip', to: 'procurements/contracts/documents#zip_contracts'
      get '/download/zip', to: 'procurements/contracts/documents#download_zip_contracts'
      resources :contracts, only: %i[show edit update], controller: 'procurements/contracts' do
        resources :sent, only: %i[index], controller: 'procurements/contracts/sent'
        resources :closed, only: %i[index], controller: 'procurements/contracts/closed'
        get '/documents/call-off-schedule', to: 'procurements/contracts/documents#call_off_schedule'
        get '/documents/call-off-schedule-2', to: 'procurements/contracts/documents#call_off_schedule_2'
      end
      resources :copy_procurement, only: %i[new create], controller: 'procurements/copy_procurement'
    end
    resources :procurement_buildings, only: %i[show edit update]
    resources :procurement_buildings_services, only: %i[show update]
    resources :buyer_details, only: %i[show edit update] do
      get 'edit_address'
    end
    namespace :supplier do
      get '/', to: 'home#index'
      resources :dashboard, only: :index
      resources :contracts, only: %i[show edit update], controller: 'contracts' do
        resources :sent, only: %i[index], controller: 'sent'
      end
    end
    namespace :admin, path: 'admin' do
      get '/', to: 'admin_account#admin_account'
      get '/gateway', to: 'gateway#index'
      get 'call-off-benchmark-rates', to: 'supplier_rates#supplier_benchmark_rates'
      put 'update-call-off-benchmark-rates', to: 'supplier_rates#update_supplier_benchmark_rates'
      get 'average-framework-rates', to: 'supplier_rates#supplier_framework_rates'
      put 'update-average-framework-rates', to: 'supplier_rates#update_supplier_framework_rates'
      get 'supplier-framework-data', to: 'suppliers_framework_data#index'
      get 'management-report', to: 'management_report#index'
      put 'update-management-report', to: 'management_report#update'
      get 'sublot-regions/:id/:lot_type', to: 'sublot_regions#sublot_region', as: 'get_sublot_regions'
      put 'sublot-regions/:id/:lot_type', to: 'sublot_regions#update_sublot_regions'
      get 'sublot-data/:id', to: 'sublot_data_services_prices#index', as: 'get_sublot_data'
      put 'sublot-data/:id', to: 'sublot_data_services_prices#update_sublot_data_services_prices'
      get 'sublot-services/:id/:lot', to: 'sublot_services#index', as: 'get_sublot_services'
      put 'sublot-services/:id/:lot', to: 'sublot_services#update', as: 'update_sublot_services'
    end

    get '/start', to: 'journey#start', as: 'journey_start'
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
    get '/html/select-lot', to: 'html#select_lot'
    get '/html/select-services', to: 'html#select_services'
    get '/html/select-location', to: 'html#select_location'
    get '/html/supplier-detail', to: 'html#supplier_detail'
    get '/html/download-the-supplier-list', to: 'html#download_the_supplier_list'
    namespace :admin do
      resources :uploads, only: %i[index new create show] do
        get 'approve'
        get 'reject'
        get 'uploading'
      end
      get '/in_progress', to: 'uploads#in_progress'
    end
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'legal_services', path: 'legal-services' do
    get '/cognito', to: 'gateway#index', cognito_enabled: true
    get '/gateway', to: 'gateway#index'
    get '/', to: 'home#index'
    get '/service-not-suitable', to: 'home#service_not_suitable'
    get '/suppliers/download', to: 'suppliers#download'
    get '/suppliers/no-suppliers-found', to: 'suppliers#no_suppliers_found'
    get '/suppliers/cg-no-suppliers-found', to: 'suppliers#cg_no_suppliers_found'
    resources :suppliers, only: %i[index show]
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :downloads, only: :index
    namespace :admin do
      resources :uploads, only: %i[index new create show] do
        get 'approve'
        get 'reject'
        get 'uploading'
      end
      get '/in_progress', to: 'uploads#in_progress'
    end
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  get '/errors/404'
  get '/errors/422'
  get '/errors/500'
  get '/errors/maintenance'

  if Marketplace.dfe_signin_enabled?
    get '/auth/dfe', as: :dfe_sign_in
    get '/auth/dfe/callback' => 'auth#callback'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v2 do
      resources :postcodes, only: :show
      get '/search-postcode/:postcode', to: 'nuts#show_post_code'
      get '/search-nuts-code/:code', to: 'nuts#show_nuts_code'
      get '/find-region/:postcode', to: 'nuts#find_region_query'
      get '/find-region-postcode/:postcode', to: 'nuts#find_region_query_by_postcode'
    end
  end

  get '/:journey/start', to: 'journey#start', as: 'journey_start'
  get '/:journey/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
# rubocop:enable Metrics/BlockLength
