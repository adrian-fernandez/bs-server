root to: 'admin/dashboard#index'
resources :users do
  collection do
    get :login
    post :login
    get :logout
  end
end

ActiveAdmin.routes(self)
