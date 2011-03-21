OpenneoIdRails::Application.routes.draw do
  devise_for :users

  resources :users do
    resource :avatar, :only => [:show]
  end

  match '/finalize-login-to/:app', :to => 'home#finalize_login',
    :as => 'finalize_login', :constraints => {:app => /[a-z0-9\.]+/}

  root :to => 'home#index'
end

