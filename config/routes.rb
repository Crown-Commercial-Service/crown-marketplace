Rails.application.routes.draw do
  get '/', to: 'home#index', as: :homepage
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :branches, only: :index
end
