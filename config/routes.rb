Rails.application.routes.draw do
  resource :session, controller: 'stormpath/rails/sessions', only: [:create]
  resource :users, controller: 'stormpath/rails/users', only: :create
  get    Stormpath::Rails.config.register.uri => 'stormpath/rails/users#new', as: 'sign_up'
  get    '/verify'   => 'stormpath/rails/users#verify', as: 'verify'

  get    Stormpath::Rails.config.login.uri => 'stormpath/rails/sessions#new', as: 'sign_in'
  delete Stormpath::Rails.config.logout.uri => 'stormpath/rails/sessions#destroy', as: 'sign_out'
  get    Stormpath::Rails.config.id_site.uri => 'stormpath/rails/sessions#redirect', as: 'redirect'
  get    '/omniauth_login' => 'stormpath/rails/omniauth#create', as: 'omniauth_login' 

  get    Stormpath::Rails.config.forgot_password.uri => 'stormpath/rails/passwords#forgot', as: 'forgot'
  post   Stormpath::Rails.config.forgot_password.uri => 'stormpath/rails/passwords#forgot_send', as: 'forgot_send'
  get    '/forgot/change' => 'stormpath/rails/passwords#forgot_change', as: 'forgot_change'
  post   '/forgot/change/:account_url' => 'stormpath/rails/passwords#forgot_update', as: 'forgot_update'
end
