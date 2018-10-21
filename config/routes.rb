# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  get '/status', to: 'home#status'

  resources :branches, only: :index
  resources :uploads, only: :create

  get '/hire-via-agency',
      to: 'search#hire_via_agency_question',
      as: 'hire_via_agency_question'
  get '/hire-via-agency-answer',
      to: 'search#hire_via_agency_answer'
  get '/managed-service-provider',
      to: 'search#managed_service_provider_question',
      as: 'managed_service_provider_question'
  get '/managed-service-provider-answer',
      to: 'search#managed_service_provider_answer'
  get '/nominated-worker',
      to: 'search#nominated_worker_question',
      as: 'nominated_worker_question'
  get '/nominated-worker-answer',
      to: 'search#nominated_worker_answer'
  get '/school-postcode',
      to: 'search#school_postcode_question',
      as: 'school_postcode_question'
  get '/school-postcode-answer',
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
  get '/school-payroll-answer',
      to: 'search#school_payroll_answer'
  get '/agency-payroll-outcome',
      to: 'search#agency_payroll_outcome'

  get '/master-vendor-managed-service-providers',
      to: 'suppliers#master_vendor_managed_service_providers',
      as: 'master_vendor_managed_service_providers'

  get 'auth/cognito/callback' => 'auth#callback'
end
# rubocop:enable Metrics/BlockLength
