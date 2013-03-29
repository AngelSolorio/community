Community::Application.routes.draw do
  resources :events

  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

  get "/contacto" => "contact_form#new", as: :contact_form_new
  post "/contacto" => "contact_form#create", as: :contact_form

  get "/privacidad" => "home#privacy"
  get "/acerca" => "home#about"

  get "/:id" => "home#show", as: :static

  if Rails.env.test?
    post '/sessions/create' => 'sessions#create'
  end

  root to: "home#index"

end
