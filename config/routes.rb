Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  get '/supply-teachers', to: 'home#supply-teachers', as: :supply_teachers
  get '/facilities-management', to: 'home#facilities-management', as: :facilities_management
  get '/facilities-management-placeholder',
      to: 'home#facilities-management-placeholder',
      as: :facilities_management_placeholder
  get '/status', to: 'home#status'

  resources :branches, only: :index
  resources :uploads, only: :create

  get '/master-vendors', to: 'suppliers#master_vendors', as: 'master_vendors'
  get '/neutral-vendors', to: 'suppliers#neutral_vendors', as: 'neutral_vendors'

  get '/agency-payroll-results',
      to: 'branches#index',
      slug: 'agency-payroll-results'
  get '/fixed-term-results',
      to: 'branches#index',
      slug: 'fixed-term-results'
  get '/nominated-worker-results',
      to: 'branches#index',
      slug: 'nominated-worker-results'

  get '/:slug', to: 'search#question', as: 'search_question'
  get '/:slug/answer', to: 'search#answer', as: 'search_answer'
end
