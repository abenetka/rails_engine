Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get '/find', to: 'search#show'
      end

      namespace :merchants do
        get '/find', to: 'search#show'
        get '/most_revenue', to: 'most_revenue#index'
        get '/most_items', to: 'most_items#index'
        get '/revenue', to: 'revenue#index'
      end

      namespace :transactions do
        get '/find', to: 'search#show'
      end

      namespace :invoice_items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      namespace :invoices do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      namespace :items do
        get '/find', to: 'search#show'
      end

      resources :customers, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :merchants, only: [:index, :show]
      resources :transactions, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :invoices, only: [:index, :show]
    end
  end
end
