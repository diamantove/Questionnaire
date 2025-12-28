Rails.application.routes.draw do
  devise_for :users

  resources :surveys do
    collection do
      post :build_form
    end

    member do
      post :build_form
      get :stats
      get :take, to: "submissions#new", as: :take
    end
  end

  resources :submissions, only: [ :create ]
  root "surveys#index"
end
