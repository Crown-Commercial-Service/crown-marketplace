Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  get '/supply-teachers', to: 'home#supply_teachers'
  get '/facilities-management', to: 'home#facilities_management'
  get '/status', to: 'home#status'

  resources :branches, only: :index

  resources :uploads, only: :create
  resources :facilities_management_uploads, only: :create

  get '/:journey/master-vendors', to: 'suppliers#master_vendors', as: 'master_vendors'
  get '/:journey/neutral-vendors', to: 'suppliers#neutral_vendors', as: 'neutral_vendors'

  get '/:journey/agency-payroll-results',
      to: 'branches#index',
      slug: 'agency-payroll-results'
  get '/:journey/fixed-term-results',
      to: 'branches#index',
      slug: 'fixed-term-results',
      as: 'fixed_term_results'
  get '/:journey/nominated-worker-results',
      to: 'branches#index',
      slug: 'nominated-worker-results'

  get '/:journey/suppliers', to: 'facilities_management_suppliers#index', as: 'facilities_management_suppliers'

  get '/:journey', to: 'journey#index', as: 'journey_start'
  get '/:journey/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
