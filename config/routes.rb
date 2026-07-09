Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth
      post   'auth/sign_in',  to: 'auth#sign_in'
      post   'auth/sign_up',  to: 'auth#sign_up'
      delete 'auth/sign_out', to: 'auth#sign_out'
      get    'auth/me',       to: 'auth#me'

      # Public
      get 'home', to: 'home#index'
      resources :products,         only: [:index, :show]
      resources :categories,       only: [:index, :show]
      resources :subcategories,    only: [:index, :show]
      resources :marques,          only: [:index, :show]
      resources :slider_images,    only: [:index]
      resources :orders,           only: [:index, :create]
      resources :contact_requests, only: [:create]
      post 'coupons/validate', to: 'coupons#validate'
      resources :faqs,    only: [:index]
      resources :astuces, only: [:index, :show]
      get  'reviews',        to: 'reviews#index'
      post 'reviews',        to: 'reviews#create'
      get  'reviews/mine',   to: 'reviews#my_reviews'

      # Admin
      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        resources :products do
          collection { delete :destroy_all }
        end
        resources :categories
        resources :subcategories
        resources :marques
        resources :orders, only: [:index, :show, :destroy] do
          member { patch :update_status }
        end
        resources :slider_images do
          member { patch :toggle_active }
        end
        resources :contact_requests, only: [:index, :show, :update, :destroy]
        resource  :settings, only: [:show, :update]
        resources :coupons
        resources :faqs
        resources :reviews,  only: [:index, :update, :destroy]
        resources :astuces
        post 'uploads', to: 'uploads#create'
      end
    end
  end

  # Health check
  get 'up', to: proc { [200, {}, ['ok']] }
end
