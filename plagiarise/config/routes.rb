Rails.application.routes.draw do
  root to: 'publications#index'

  resources :publications
  resources :sentences
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
