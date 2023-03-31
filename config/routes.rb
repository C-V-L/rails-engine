Rails.application.routes.draw do
  namespace :api do
    
    namespace :v1 do
      get '/merchant/find', to: 'merchant_find#show'
      get '/items/find_all', to: 'item_find#index'
      
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: 'item_merchant'
      end
      
    end
  end
end
