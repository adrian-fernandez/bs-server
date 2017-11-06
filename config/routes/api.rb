namespace :api do
  namespace :v1 do
    resources :clients, only: %i[create index show update destroy]

    resources :users, only: %i[create index show update destroy] do
      get :me, on: :collection
    end

    resources :user_sessions do
      collection do
        post :create, format: true, defaults: { format: :json }
        delete :destroy, format: true, defaults: { format: :json }
      end
    end

    resources :rentals do
      member do
        get :bookings
      end

      collection do
        get :rental_daily_rate_ranges
      end
    end
    resources :bookings
  end
end
