module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :set_user, except: [:index]
    before_action :set_plan, only: [:create_user_viewed_plan]

    # GET /users
    def index
      @paged = User.filtered_page(params)
    end

    # GET /users/:id
    def show
      @user
    end

    # GET /users/:id/roles
    def roles
    end

    # PUT /users/:id
    def update
      if @user.update(user_params)
        head :no_content
      else
        json_response_error(@user.errors.full_messages)
      end
    end

    # GET /users/:id/builders
    def builders
      @paged = @user.builders.filtered_page(params)
      render 'v1/builders/index'
    end
    
    #POST /users/:id/viewed_plan/:plan_id 
    def create_user_viewed_plan
      @user_viewed_plan = @user.user_viewed_plans.new(plan_id: @plan.id)
      if @user_viewed_plan.save
        json_response(@user_viewed_plan, :created)
      else
        json_response_error(@user_viewed_plan.errors.full_messages)
      end
    end

    #GET /users/:user_id/viewed_plans
    def viewed_plans
      @paged = @user.viewed_plans.group(:id).paged(params)
      render 'v1/plans/index'
    end

    private

    def user_params
      params.permit(:name, :profile, :uid, :provider,
        :encrypted_password, :reset_password_token, 
        :reset_password_sent_at, :allow_password_change,
        :remember_created_at, :sign_in_count,
        :current_sign_in_at, :last_sign_in_at,
        :current_sign_in_ip, :last_sign_in_ip,
        :confirmation_token, :confirmed_at,
        :confirmation_sent_at, :unconfirmed_email,
        :failed_attempts, :unlock_token,
        :locked_at, :email, :tokens, 
        :created_at, :updated_at)
    end

    def set_user
      @user = User.find(params[:id])
      unless current_user == @user
        json_response({"Acess Denied" => "User can only access own information"}, 403)
      end
    end

    def set_plan
      @plan = Plan.find(params[:plan_id])
    end  

  end
end
