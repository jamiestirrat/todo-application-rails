Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root "pages#my_todo_items", as: :authenticated_root
  end
  root 'pages#home'
  # by namespace we make our routes render at /api/v1 meaning we can easily add new api versions later
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :todo_items, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
