Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    omniauth_callbacks: "overrides/omniauth_callbacks",
  }

  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :plans, only: [:index], format: "json"
  end

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :builders, only: [:index, :create, :show, :update, :destroy] do #, :update, :destroy]
      resources :regions, only: [:index, :create]
      get :communities, on: :member
      get :collections, on: :member
      get :plans, on: :member
      get :users, on: :member
      post 'users/:user_id', on: :member, to: 'builders#create_users_builders'
      delete 'users/:user_id', on: :member, to: 'builders#destroy_users_builders'
      resources :contacts, only: %I[index create]
    end

    resources :regions, only: [:show, :update, :destroy] do
      resources :collections, only: [:index, :create]
      resources :divisions, only: [:index, :create]
    end

    resources :collections, only: [:show, :update, :destroy] do 
      get :plans, on: :member
      resources :plans, only: [:index, :create]
    end

    resources :communities, only: [:update, :show, :destroy] do 
      resources :lots, only: [:index, :create]
      get :plans, on: :member
      post 'plans/:plan_id', on: :member, to: 'communities#create_communities_plans'
      put "plans/:plan_id", on: :member, to: 'communities#update_communities_plans'    
      delete 'plans/:plan_id', on: :member, to: 'communities#destroy_communities_plans'
      post 'gallery', on: :member, to: 'communities#create_gallery'
      get :gallery, on: :member

      get :amenities, on: :member
      post 'amenities/:amenity_id', on: :member, to: 'communities#create_communities_amenities'
      delete 'amenities/:amenity_id', on: :member, to: 'communities#destroy_communities_amenities'
    end

    resources :divisions, only: [:show, :update, :destroy] do 
      resources :contacts, only: [:index, :create]
      resources :lots, only: [:index, :show] #, :create]
      get 'plans', on: :member, to: 'divisions#plans'
      resources :communities, only: [:index, :create]
    end

    resources :lots, only: [] do
      get :plans, on: :member
      # post 'amenities/:amenity_id', on: :member, to: 'communities#create_communities_amenities'
      # delete 'amenities/:amenity_id', on: :member, to: 'communities#destroy_communities_amenities'
    end

    post 'amenities', to: 'amenities#create'
    get 'amenities', to: 'amenities#search'

    resources :contacts, only: [:show, :update, :destroy]

    resources :lots, only: [:show, :update, :destroy]

    resources :plans, only: [:index, :show, :update, :destroy] do 
      get :price_range, on: :collection
      get :count, on: :collection
      get :styles, on: :collection
      get :communities, on: :member
      get :plan_styles, on: :member
      get :vr, on: :member
      post 'plan_styles/:plan_style_id', on: :member, to: 'plans#create_plans_plan_style'
      delete 'plan_styles/:plan_style_id', on: :member, to: 'plans#destroy_plans_plan_style'
      get :lots, on: :member
      post 'lots/:lot_id', on: :member, to: 'plans#create_plans_lots'
      delete 'lots/:lot_id', on: :member, to: 'plans#destroy_plans_lots'
      get :viewed_users, on: :member
      get :gallery, on: :member
      post 'gallery', on: :member, to: 'plans#create_gallery' 


      resources :plan_option_sets, only: [:index, :create]

      resources :elevations, only: [:index] #, :create]
      resources :vr_scenes, only: [:index, :create]
    end

    resources :vr_scenes, only: [:show, :update, :destroy] do 
      resources :vr_hotspots, only: [:index, :create]
    end

    resources :vr_hotspots, only: [:show, :update, :destroy]
    
    resources :plan_option_sets, only: [:show, :update, :destroy] do 
      resources :plan_options, only: [:index, :create]
    end
    
    resources :plan_styles, only: [:index] do
      get :plans, on: :member
    end
    
    resources :plan_options, only: [:show, :update, :destroy] do 
      get :excluded_plan_options, on: :member
      get :communities, on: :member
      put 'communities/:community_id', on: :member, to: 'plan_options#update_plan_options_communities'

    end

    resources :elevations, only: [:show] #, :update, :destroy]

    resources :users, only: [:index, :show, :update] do
      get :roles, on: :member
      resources :saved_plans, shallow: true
      resources :saved_searches, shallow: true
      get :builders, on: :member
      get :viewed_plans, on: :member
      post '/viewed_plans/:plan_id', on: :member, to: 'users#create_user_viewed_plan'
    end

    post '/saved_plans', to: 'saved_plans#guest_create'
    resources :saved_plans, only: [:show, :update, :destroy] do 
      resources :saved_plan_options, only: [:index, :create]
    end

    resources :saved_plan_options, only: [:show, :destroy] #, :update
    
    resources :locations, only: [:index] do
      get :attractions, on: :collection
      get :downtown_importance, on: :collection
    end
    
    resources :plan_rooms, only: %I[index]
    resources :plan_gallery, only: %I[destroy]
    resources :community_gallery, only: %I[destroy]  
  end
end
