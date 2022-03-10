Rails.application.routes.draw do
  get '/', to: 'static_pages#welcome'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'

  # Defines the root path route ("/")
  # root "articles#index"
end
