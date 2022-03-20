Rails.application.routes.draw do
  get '/', to: 'static_pages#welcome'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  post '/bookuser/new', to: 'books#new_book_user'
  delete '/bookuser/:id', to: 'books#destroy_book_user'

  post '/books/:book_id/articles/:article_id/lock', to: 'articles#switch_is_locked'
  post '/books/:book_id/public', to: 'books#switch_is_public'

  resources :users

  resources :books do
    resources :articles
  end

  get '/books/:book_id/articles/:parent_id/new', to: 'articles#new_subarticle'
end
