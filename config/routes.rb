Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  get '/status', to: 'home#status'

  namespace 'supply_teachers', path: 'supply-teachers' do
    get '/', to: 'home#index'
    resources :branches, only: :index
    resources :uploads, only: :create
  end
  namespace 'facilities_management', path: 'facilities_management' do
    get '/', to: 'home#index'
    resources :uploads, only: :create
  end
  namespace 'management_consultancy', path: 'management-consultancy' do
    get '/', to: 'home#index'
  end

  get '/:journey/master-vendors', to: 'suppliers#master_vendors', as: 'master_vendors'
  get '/:journey/neutral-vendors', to: 'suppliers#neutral_vendors', as: 'neutral_vendors'

  get '/:journey/agency-payroll-results',
      to: 'supply_teachers/branches#index',
      slug: 'agency-payroll-results'
  get '/:journey/fixed-term-results',
      to: 'supply_teachers/branches#index',
      slug: 'fixed-term-results',
      as: 'fixed_term_results'
  get '/:journey/nominated-worker-results',
      to: 'supply_teachers/branches#index',
      slug: 'nominated-worker-results'

  get '/:journey/suppliers', to: 'facilities_management_suppliers#index', as: 'facilities_management_suppliers'

  get '/:journey/start', to: 'journey#start', as: 'journey_start'
  get '/:journey/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
