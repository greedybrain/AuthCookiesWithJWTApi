Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      resources :users, only: %i[index]

      get :logged_in, to: 'sessions#logged_in'
      post :login, to: 'sessions#login'
      delete :logout, to: 'sessions#logout'
    end
  end
end