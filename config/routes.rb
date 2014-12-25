PostitTemplate::Application.routes.draw do
  root to: 'posts#index'


  # get '/posts', to: 'posts#index'
  # get '/posts/:id', to: 'posts#show'

  resources :posts, except: [:destroy] do
  	resources :comments, only: [:create]
	end
	resources :categories, only: [:new, :create, :show]
end
