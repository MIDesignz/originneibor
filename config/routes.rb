Rails.application.routes.draw do
  devise_for :users, controllers: {
                                    registrations: "registrations",
                                    sessions: 'sessions',
                                    omniauth_callbacks: "users/omniauth_callbacks"
                                  }

  get 'wepay' => 'we_pay#oauth_callback'
  get 'wepay_contrib' => 'we_pay#contrib'
  get 'go-fund-me' => 'we_pay#update_uri', as: :update_uri

  authenticated :user do
    #devise_scope :user do
    #  get 'users/payment' => 'registrations#payment'
    #  get 'users' => 'registrations#index'
    #  get 'users/:id' => 'registrations#show'
    #  delete 'users/:card_id' => 'registrations#delete_card', as: 'users_delete_card'
    #  post 'users/:id/create_card' => 'registrations#create_card', as: 'users_create_card'
    #end

    get 'campaigns/mine' => 'campaigns#mine'
    get 'contributions/mine' => 'contributions#mine'
    get 'campaigns/search' => 'campaigns#search'
    get 'campaigns/:id/close' => 'campaigns#close', as: :close_campaign
    get 'campaigns/:id/notification' => 'campaigns#show_by_notification', as: :show_by_notification
    get 'notifications' => 'notifications#index'

    resources :campaigns, except: [:show] do
      member do
        get 'resubmit_for_approval'
      end
      resources :contributions
    end
    get 'campaigns/:id/payment_success' => "campaigns#payment_success"

    root to: 'campaigns#index', as: 'campaigns_root_index'
  end
  get 'questions' => 'faqs#index', as: :faqs
  get 'blogs' => 'faqs#blogs', as: :blogs
  get 'blogs/:id' => 'faqs#view_blog', as: :blog

  unauthenticated do
    #devise_scope :user do
    #  get 'users/confirm' => 'registrations#confirm_registration'
    #  get 'sign_in' => 'home#index'
    #end
    get 'campaigns' => 'campaigns#index'
    get 'campaigns/search' => 'campaigns#search'
    root to: 'home#index'
  end
  resources :campaigns, only: [:show]

  namespace :admin do
    get 'dashboard' => 'dashboard#index', as: :dashboard
    get 'settings/email' => 'settings#smtp_settings', as: :smtp_settings
    get 'settings/payment' => 'settings#payment_settings', as: :payment_settings
    get 'settings/other' => 'settings#other_settings', as: :other_settings

    patch 'settings/update_payment_settings'

    resources :reports
    resources :users do
      collection do
        get 'active_users'
        get 'banned_users'
      end
      member do
        get 'mark_banned'
      end
    end
    resources :campaigns do
      collection do
        get 'featured_campaigns' => 'campaigns#featured_campaigns', as: :featured_campaigns
      end
      member do
        get 'approve'
        get 'reject'
        get 'mark_as_featured'
      end
    end
    resources :faqs
    resources :faq_categories
    # get 'campaigns/active' => "campaigns#active", as: :active_campaign
  end
end
