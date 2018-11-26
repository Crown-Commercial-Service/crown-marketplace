# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  get '/', to: 'home#gateway', as: :gateway
  get '/start', to: 'home#index', as: :homepage

  get '/status', to: 'home#status'

  namespace 'supply_teachers', path: 'supply-teachers' do
    get '/', to: 'home#index'
    get '/master-vendors', to: 'suppliers#master_vendors', as: 'master_vendors'
    get '/neutral-vendors', to: 'suppliers#neutral_vendors', as: 'neutral_vendors'
    get '/agency-payroll-results', to: 'branches#index', slug: 'agency-payroll-results'
    get '/fixed-term-results', to: 'branches#index', slug: 'fixed-term-results', as: 'fixed_term_results'
    get '/nominated-worker-results', to: 'branches#index', slug: 'nominated-worker-results'
    resources :branches, only: :index
    resources :uploads, only: :create
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  namespace 'facilities_management', path: 'facilities-management' do
    get '/', to: 'home#index'
    get '/suppliers', to: 'suppliers#index'
    resources :uploads, only: :create
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  namespace 'management_consultancy', path: 'management-consultancy' do
    get '/', to: 'home#index'
    get '/suppliers', to: 'suppliers#index'
    resources :uploads, only: :create
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  namespace 'temp_to_perm_calculator', path: 'temp-to-perm-calculator' do
    get '/', to: 'home#index'
    get '/fee', to: 'home#fee'
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  get '/auth/cognito', as: :cognito_sign_in
  get '/auth/cognito/callback' => 'auth#callback'
  post '/auth/cognito/logout' => 'auth#logout', as: :logout

  get '/:journey/start', to: 'journey#start', as: 'journey_start'
  get '/:journey/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
# rubocop:enable Metrics/BlockLength
