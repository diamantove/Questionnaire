Rails.application.routes.draw do
  devise_for :users

  resources :surveys do
    # Маршруты, которые относятся ко ВСЕМ опросам (например, создание нового)
    collection do
      post :build_form # Генерирует build_form_surveys_path
    end

    # Маршруты, которые относятся к КОНКРЕТНОМУ опросу (нужен ID)
    member do
      post :build_form # Генерирует build_form_survey_path(@survey)
      get :stats
      get :take, to: "submissions#new", as: :take
    end
  end

  resources :submissions, only: [ :create ]
  root "surveys#index"
end
