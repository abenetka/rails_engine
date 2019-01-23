Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get '/find', to: 'search#show'
      end

      namespace :merchants do
        get '/find', to: 'search#show'
      end

      resources :customers, only: [:index, :show]

      resources :items, only: [:index]
      resources :merchants, only: [:index, :show]
    end
  end
end
