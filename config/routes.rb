OpenneoIdRails::Application.routes.draw do
  devise_for :users

  match '/finalize-login-to/:app', :to => 'home#finalize_login',
    :as => 'finalize_login', :constraints => {:app => /[a-z0-9\.]+/}
  
  root :to => 'home#index'
end
