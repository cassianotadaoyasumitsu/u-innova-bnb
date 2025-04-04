Rails.application.routes.draw do
  devise_for :users
  
  resources :listings do
    resources :bookings, only: [:new, :create]
  end
  
  resources :bookings, only: [:index, :show, :edit, :update, :destroy]
  
  # Host bookings routes
  get 'host/bookings', to: 'bookings#host_index', as: :host_bookings

  # Role switching routes
  post 'users/become_host', to: 'users#become_host', as: :become_host
  post 'users/become_guest', to: 'users#become_guest', as: :become_guest

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
