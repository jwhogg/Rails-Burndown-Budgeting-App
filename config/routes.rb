Rails.application.routes.draw do
  get 'find_bank/index'
  get 'find_bank/activate_bank'
  get 'transaction/index'
  get 'transaction/linked'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "home#index"
  post 'activate_bank', to: 'find_bank#activate_bank'
  get 'find_bank', to: 'find_bank#index'
  get 'link_landingpage', to: 'transaction#linked'
end
