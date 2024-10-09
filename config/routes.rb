require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

   resources :catalogues do
    collection do
      get :search
    end
  end

  resources :wishlists
  resources :offers


  resources :users  do
    collection do 
      post :login
    end
  end

  resources :catalogue_variants do
    collection do
      get :emi
    end
  end


  resources :carts
  resources :cart_items

 resources :payments, only: [] do
        collection do
          post 'purchase'
          post 'purchase_single_item'
        end
      end
      
  resources :subscriptions

  mount Sidekiq::Web => '/sidekiq'

end
