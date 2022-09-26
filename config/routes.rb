# rubocop:disable Metrics/BlockLength
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  get '/', to: 'home#index'
  get '/status', to: 'home#status'

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
      get '/users/password', to: 'passwords#edit', as: :edit_user_password
      put '/users/password', to: 'passwords#update'
      get '/users/password-reset-success', to: 'passwords#password_reset_success', as: :password_reset_success
      get '/users/confirm', to: 'users#confirm_new'
      post '/users/confirm', to: 'users#confirm'
      get '/users/challenge', to: 'users#challenge_new'
      post '/users/challenge', to: 'users#challenge'
      post '/resend_confirmation_email', to: 'users#resend_confirmation_email', as: :resend_confirmation_email
    end
    concern :registrable do
      get '/sign-up', to: 'registrations#new', as: :new_user_registration
      post '/sign-up', to: 'registrations#create', as: :user_registration
      get '/domain-not-on-safelist', to: 'registrations#domain_not_on_safelist', as: :domain_not_on_safelist
    end

    delete '/sign-out', to: 'base/sessions#destroy', as: :destroy_user_session

    namespace 'facilities_management', path: 'facilities-management', defaults: { service: 'facilities_management' } do
      namespace 'rm3830', path: 'RM3830', defaults: { framework: 'RM3830' } do
        concerns %i[authenticatable registrable]
        namespace :supplier, defaults: { service: 'facilities_management/supplier' } do
          concerns :authenticatable
        end
        namespace :admin, defaults: { service: 'facilities_management/admin' } do
          concerns :authenticatable
        end
      end
      namespace 'rm6232', path: 'RM6232', defaults: { framework: 'RM6232' } do
        concerns %i[authenticatable registrable]
        namespace :admin, defaults: { service: 'facilities_management/admin' } do
          concerns :authenticatable
        end
      end
    end

    namespace :crown_marketplace, path: 'crown-marketplace', defaults: { service: 'crown_marketplace' } do
      concerns :authenticatable
    end

    get 'active'  => 'base/sessions#active'
    get 'timeout' => 'base/sessions#timeout'
  end

  concern :shared_pages do
    get '/not-permitted', to: 'home#not_permitted'
    get '/accessibility-statement', to: 'home#accessibility_statement'
    get '/cookie-policy', to: 'home#cookie_policy'
    get '/cookie-settings', to: 'home#cookie_settings'
    put '/cookie-settings', to: 'home#update_cookie_settings'
  end

  concern :framework do
    get '/', to: 'home#framework'
    get '/start', to: 'home#framework'
  end

  namespace 'facilities_management', path: 'facilities-management', defaults: { service: 'facilities_management' } do
    concern :buildings do
      resources :buildings, only: %i[index show edit update new create]
    end

    concern :edit_buildings do
      resources :edit_buildings, path: 'edit-buildings', only: %i[show edit update new create]
    end

    concern :procurement_details do
      resources :procurement_details, path: 'procurement-details', param: :section, only: %i[show edit update]
    end

    concern :procurement_buildings do
      namespace 'procurement_buildings', path: 'procurement-buildings/:id' do
        get '/:section/edit', action: :edit
        put '/:section/', action: :update
      end
      get 'procurements/:procurement_id/missing-regions', as: :missing_regions, to: 'procurement_buildings#missing_regions'
    end

    concerns :framework

    resources :buyer_details, path: '/:framework/buyer-details', only: %i[edit update] do
      get 'edit-address', as: :edit_address
    end

    namespace :supplier, defaults: { service: 'facilities_management/supplier' } do
      concerns :framework
    end

    namespace :admin, path: 'admin', defaults: { service: 'facilities_management/admin' } do
      concerns :framework
      resources :frameworks, only: %i[index edit update]
    end

    resources :admin_supplier_details, path: '/:framework/admin/supplier-details', only: %i[show edit update], defaults: { service: 'facilities_management/admin' }, controller: 'admin/supplier_details'

    concern :admin_uploads do
      resources :uploads, only: %i[index new create show] do
        get '/progress', action: :progress
      end
    end

    concern :management_reports do
      resources :management_reports, path: 'management-reports', only: %i[index new create show] do
        member do
          get '/progress', action: :progress
        end
      end
    end

    namespace 'rm3830', path: 'RM3830', defaults: { framework: 'RM3830' } do
      concerns :shared_pages, :buildings, :procurement_buildings

      get '/start', to: 'home#index'
      get '/', to: 'buyer_account#index'
      get '/service-specification/:service_code/:work_package_code', to: 'service_specification#show', as: 'service_specification'
      get 'procurements/what-happens-next', as: 'what_happens_next', to: 'procurements#what_happens_next'
      resources :procurements do
        concerns :procurement_details, :edit_buildings

        get 'delete'
        get 'quick_view_results_spreadsheet'
        get 'further_competition_spreadsheet'
        get 'deliverables_matrix'
        get 'price_matrix'
        namespace 'contract_details', path: 'contract-details', controller: '/facilities_management/rm3830/procurements/contract_details' do
          get '/', action: 'show'
          put '/', action: 'update'
          patch '/', action: 'update'
          get '/edit', action: 'edit'
        end
        resources :contracts, only: %i[show edit update], controller: 'procurements/contracts' do
          resources :sent, only: %i[index], controller: 'procurements/contracts/sent'
          resources :closed, only: %i[index], controller: 'procurements/contracts/closed'
          namespace :documents, controller: '/facilities_management/rm3830/procurements/contracts/documents' do
            get '/call-off-schedule', action: :call_off_schedule
            get '/call-off-schedule-2', action: :call_off_schedule_2
            get '/zip', action: :zip_contracts
          end
        end
        resources :copy_procurement, only: %i[new create], controller: 'procurements/copy_procurement'
        resources :spreadsheet_imports, only: %i[new create show destroy], controller: 'procurements/spreadsheet_imports' do
          get '/progress', action: :progress
        end
      end
      resources :procurement_buildings, path: 'procurement-buildings', only: :show
      resources :procurement_buildings_services, only: %i[edit update]

      namespace :supplier, defaults: { service: 'facilities_management/supplier' } do
        concerns :shared_pages

        get '/', to: 'home#index'
        resources :dashboard, only: :index
        resources :contracts, only: %i[show edit update], controller: 'contracts' do
          resources :sent, only: %i[index], controller: 'sent'
        end
      end

      namespace :admin, path: 'admin', defaults: { service: 'facilities_management/admin' } do
        get '/uploads/spreadsheet_template', controller: 'facilities_management/rm3830/admin/uploads'

        concerns :shared_pages, :admin_uploads, :management_reports

        get '/', to: 'home#index'
        resources :service_rates, path: 'service-rates', param: :slug, only: %i[edit update]
        resources :supplier_framework_data, path: 'supplier-framework-data', only: :index do
          resources :sublot_regions, path: 'sublot-regions', param: :lot, only: %i[edit update]
          resources :sublot_services, path: 'sublot-services', param: :lot, only: %i[edit update]
        end
        resources :supplier_details, path: 'supplier-details', only: :index
      end
    end

    namespace 'rm6232', path: 'RM6232', defaults: { framework: 'RM6232' } do
      concerns :shared_pages
      # This has been cut but it may return on the future: concerns :buildings, :procurement_buildings

      get '/start', to: 'home#index'
      get '/', to: 'buyer_account#index'
      get '/service-specification/:service_code', to: 'service_specification#show', as: 'service_specification'

      resources :procurements, only: %i[index show new create] do
        # This has been cut but it may return on the future: concerns :procurement_details, :edit_buildings
        # put 'update-show', action: 'update_show'

        get 'supplier_shortlist_spreadsheet'
      end

      namespace :admin, path: 'admin', defaults: { service: 'facilities_management/admin' } do
        concerns :shared_pages, :admin_uploads, :management_reports

        get '/', to: 'home#index'
        resources :supplier_data, path: 'supplier-data', only: :index
        resources :supplier_lot_data, path: 'supplier-lot-data', only: :show do
          get '/:lot_data_type/edit', action: :edit, as: :edit
          put '/:lot_data_type', action: :update, as: :update
        end
        resources :change_logs, path: 'change-logs', only: :index do
          get '/:change_type', action: :show, as: :show
        end
        resources :supplier_data_snapshots, path: 'supplier-data-snapshots', only: %i[new create]
      end
    end

    get '/:framework', to: 'home#index', as: 'index'
    get '/:framework/admin', to: 'admin/home#index', defaults: { service: 'facilities_management/admin' }, as: 'admin_index'
    get '/:framework/start', to: 'journey#start', as: 'journey_start'
    get '/:framework/:slug', to: 'journey#question', as: 'journey_question'
    get '/:framework/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  namespace :crown_marketplace, path: 'crown-marketplace', defaults: { service: 'crown_marketplace' } do
    concerns :shared_pages

    get '/', to: 'home#index'
    resources :allow_list, path: 'allow-list', only: %i[index new create] do
      collection do
        delete '/destroy', action: :destroy
        get '/delete', action: :delete
        get '/search_allow_list', action: :search_allow_list
      end
    end
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
      put '/update-cookie-settings', to: 'cookie_settings#update_cookie_settings'
    end
  end

  get '/:journey/:framework/start', to: 'journey#start', as: 'journey_start'
  get '/:journey/:framework/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:framework/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
# rubocop:enable Metrics/BlockLength
