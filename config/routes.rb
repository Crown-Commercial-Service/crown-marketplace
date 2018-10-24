Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  get '/status', to: 'home#status'

  resources :branches, only: :index
  resources :uploads, only: :create

  get '/master-vendors', to: 'suppliers#master_vendors', as: 'master_vendors'
  get '/neutral-vendors', to: 'suppliers#neutral_vendors', as: 'neutral_vendors'

  get '/:slug', to: 'search#question', as: 'search_question'
  get '/:slug/answer', to: 'search#answer', as: 'search_answer'
end
