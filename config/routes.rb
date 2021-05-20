# rubocop:disable Metrics/BlockLength
require 'sidekiq/web'
Rails.application.routes.draw do
  get '/', to: 'home#index'
  get '/status', to: 'home#status'
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

    namespace 'facilities_management', path: 'facilities-management', defaults: { service: 'facilities_management' } do
      concerns %i[authenticatable registrable]
      namespace :supplier, defaults: { service: 'facilities_management/supplier' } do
        concerns :authenticatable
      end
      namespace :admin, defaults: { service: 'facilities_management/admin' } do
        concerns :authenticatable
      end
    end

    get 'active'  => 'base/sessions#active'
    get 'timeout' => 'base/sessions#timeout'
  end

  concern :shared_pages do
    get '/accessibility-statement', to: 'home#accessibility_statement'
    get '/cookie-policy', to: 'home#cookie_policy'
    get '/cookie-settings', to: 'home#cookie_settings'
  end

  namespace 'facilities_management', path: 'facilities-management', defaults: { service: 'facilities_management' } do
    concerns :shared_pages
    get '/', to: 'buyer_account#buyer_account'
    get '/not-permitted', to: 'home#not_permitted'
    get '/start', to: 'home#index'
    get '/buyer_account', to: 'buyer_account#buyer_account'
    resources :buildings, only: %i[index show edit update new create] do
      member do
        match 'add_address', via: %i[get post patch]
      end
    end
    get '/service-specification/:service_code/:work_package_code', to: 'service_specification#show', as: 'service_specification'
    match 'select-services', to: 'select_services#select_services', as: 'select_FM_services', via: %i[get post]
    match '/select-locations', to: 'select_locations#select_location', as: 'select_FM_locations', via: %i[get post]
    get 'spreadsheet-test', to: 'spreadsheet_test#index', as: 'spreadsheet_test'
    get 'spreadsheet-test/dm-spreadsheet-download', to: 'spreadsheet_test#dm_spreadsheet_download', as: 'dm_spreadsheet_download'
    get 'procurements/what-happens-next', as: 'what_happens_next', to: 'procurements#what_happens_next'

    resources :procurements do
      get 'delete'
      get 'summary', to: 'procurements#summary'
      get 'quick_view_results_spreadsheet'
      get 'further_competition_spreadsheet'
      get 'deliverables_matrix'
      get 'price_matrix'
      namespace 'contract_details', path: 'contract-details', controller: '/facilities_management/procurements/contract_details' do
        get '/', action: 'show'
        put '/', action: 'update'
        patch '/', action: 'update'
        get '/edit', action: 'edit'
      end
      resources :contracts, only: %i[show edit update], controller: 'procurements/contracts' do
        resources :sent, only: %i[index], controller: 'procurements/contracts/sent'
        resources :closed, only: %i[index], controller: 'procurements/contracts/closed'
        namespace :documents, controller: '/facilities_management/procurements/contracts/documents' do
          get '/call-off-schedule', action: :call_off_schedule
          get '/call-off-schedule-2', action: :call_off_schedule_2
          get '/zip', action: :zip_contracts
          get '/download/zip', action: :download_zip_contracts
        end
      end
      resources :copy_procurement, only: %i[new create], controller: 'procurements/copy_procurement'
      resources :spreadsheet_imports, only: %i[new create show destroy], controller: 'procurements/spreadsheet_imports' do
        resources :progress, only: :index, defaults: { format: :json }, controller: 'procurements/spreadsheet_imports/progress'
      end
      resources 'edit-buildings', only: %i[show edit update new create], as: 'edit_buildings', controller: 'procurements/edit_buildings' do
        member do
          match 'add_address', via: %i[get post patch]
        end
      end
    end
    resources :procurement_buildings, only: %i[show edit update]
    resources :procurement_buildings_services, only: %i[edit update]
    resources 'buyer-details', only: %i[edit update], as: :buyer_details, controller: 'buyer_details' do
      get 'edit-address', as: :edit_address
    end
    namespace :supplier, defaults: { service: 'facilities_management/supplier' } do
      concerns :shared_pages
      get '/', to: 'home#index'
      resources :dashboard, only: :index
      resources :contracts, only: %i[show edit update], controller: 'contracts' do
        resources :sent, only: %i[index], controller: 'sent'
      end
    end
    namespace :admin, path: 'admin', defaults: { service: 'facilities_management/admin' } do
      concerns :shared_pages
      get '/', to: 'home#index'
      resources :service_rates, path: 'service-rates', param: :slug, only: %i[edit update]
      resources :supplier_framework_data, path: 'supplier-framework-data', only: :index do
        resources :sublot_regions, path: 'sublot-regions', param: :lot, only: %i[edit update]
        resources :sublot_services, path: 'sublot-services', param: :lot, only: %i[edit update]
      end
      resources :supplier_details, path: 'supplier-details', only: %i[index show edit update]
      resources :management_reports, only: %i[new create show]
    end

    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  get '/404', to: 'errors#not_found', as: :errors_404
  get '/422', to: 'errors#unacceptable', as: :errors_422
  get '/500', to: 'errors#internal_error', as: :errors_500
  get '/503', to: 'errors#service_unavailable', as: :errors_503

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
