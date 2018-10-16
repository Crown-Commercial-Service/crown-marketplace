Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  get '/status', to: 'home#status'

  resources :branches, only: :index
  resources :uploads, only: :create

  get '/hire-via-agency',
      to: 'search#hire_via_agency_question',
      as: 'hire_via_agency_question'
  get '/hire_via_agency_answer',
      to: 'search#hire_via_agency_answer'
  get '/managed-service-provider',
      to: 'search#managed_service_provider_question',
      as: 'managed_service_provider_question'
  get '/managed_service_provider_answer',
      to: 'search#managed_service_provider_answer'
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
  get '/master-vendor-managed-service',
      to: 'search#master_vendor_managed_service_outcome',
      as: 'master_vendor_managed_service_outcome'
  get '/neutral-vendor-managed-service',
      to: 'search#neutral_vendor_managed_service_outcome',
      as: 'neutral_vendor_managed_service_outcome'
  get '/school-payroll',
      to: 'search#school_payroll_question',
      as: 'school_payroll_question'
  get '/school_payroll_answer',
      to: 'search#school_payroll_answer'
  get '/agency_payroll_outcome',
      to: 'search#agency_payroll_outcome'
end
