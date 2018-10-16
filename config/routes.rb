Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage

  resources :branches, only: :index
  resources :uploads, only: :create

  get '/hire-via-agency',
      to: 'search#hire_via_agency_question',
      as: 'hire_via_agency_question'
  get '/hire_via_agency_answer',
      to: 'search#hire_via_agency_answer'
  get '/nominated-worker',
      to: 'search#nominated_worker_question',
      as: 'nominated_worker_question'
  get '/nominated_worker_answer',
      to: 'search#nominated_worker_answer'
  get '/school-postcode',
      to: 'search#school_postcode_question',
      as: 'school_postcode_question'
  get '/school_postcode_answer',
      to: 'search#school_postcode_answer'
  get '/managed-service-providers',
      to: 'search#managed_service_providers_outcome',
      as: 'managed_service_providers_outcome'
  get '/non-nominated-worker',
      to: 'search#non_nominated_worker_outcome',
      as: 'non_nominated_worker_outcome'
end
