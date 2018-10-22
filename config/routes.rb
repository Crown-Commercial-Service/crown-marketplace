Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  get '/status', to: 'home#status'

  resources :branches, only: :index
  resources :uploads, only: :create

  get '/master-vendor-managed-service-providers',
      to: 'suppliers#master_vendor_managed_service_providers',
      as: 'master_vendor_managed_service_providers'

  get '/:slug', to: 'search#question', as: 'search_question'
  get '/:slug/answer', to: 'search#answer', as: 'search_answer'
end
