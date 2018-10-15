Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :branches, only: :index
  resources :uploads, only: :create

  get '/nominated_worker_question',
      to: 'search#nominated_worker_question'
  get '/nominated_worker_answer',
      to: 'search#nominated_worker_answer'
  get '/school_postcode_question',
      to: 'search#school_postcode_question'
  get '/school_postcode_answer',
      to: 'search#school_postcode_answer'
  get '/non_nominated_worker_outcome',
      to: 'search#non_nominated_worker_outcome'
end
