Blogger::Application.routes.draw do
  root to: 'posts#index'
  resources :posts do
    resources :comments
  end

  resources :photos do
    resources :comments
  end
end
