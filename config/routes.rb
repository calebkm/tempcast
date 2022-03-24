Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Overload the root_path instead of using "resources :forecasts".
  # This guarantees the root_path is the only path in the app.
  post '/', to: 'forecasts#create'

  # Defines the root path route ("/")
  root 'application#index'
end
