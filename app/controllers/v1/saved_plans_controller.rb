module V1
  class SavedPlansController < ApplicationController
    before_action :authenticate_or_guest
    before_action :set_user, only: [:index, :create]
    before_action :set_saved_plan, except: [:index, :create, :guest_create]
    
    # GET /user/:user_id/saved_plans
    def index
      @paged = @user.saved_plans.filtered_page(params)
    end

    # GET /saved_plans/:id
    def show
      @saved_plan
    end

    # POST /users/:user_id/saved_plans
    def create
      saved_plan = @user.saved_plans.new(saved_plan_params)
      if saved_plan.save
        json_response(saved_plan, :created)
      else
        json_response_error(saved_plan.errors.full_messages)
      end
    end

    # POST /saved_plans
    def guest_create
      @user = current_or_guest_user 
      saved_plan = @user.saved_plans.pluck(:plan_id).include?(params[:plan_id])
      unless saved_plan.present?
        saved_plan = @user.saved_plans.new(saved_plan_params)
      end

      if saved_plan.save
        json_response(saved_plan, :created)
      else
        json_response_error(saved_plan.errors.full_messages)
      end
    end

    # PUT /saved_plans/:id
    def update
      if @saved_plan.update(saved_plan_params)
        head :no_content
      else
        json_response_error(@saved_plan.errors.full_messages)
      end
    end

    # DELETE /saved_plans/:id
    def destroy
      if @saved_plan.destroy
        head :no_content
      else
        head 422
      end
    end

    private

    def saved_plan_params
      params.permit(:user_id, :plan_id, :elevation_id, :contact_id, :quoted_price,
                    :ordered_at, :completed_at, :name, :description, :is_favorite, :is_public)
    end

    def set_user
      @user = User.find(params[:user_id])
      unless current_or_guest_user == @user
        json_response({"Acess Denied" => "User can only access own information"}, 403)
      end
    end

    def set_saved_plan
      @saved_plan = SavedPlan.find_by!(id: params[:id])
      if current_user.present? or session[:guest_user_id].present?
        unless current_or_guest_user == @saved_plan.user
          json_response({"Acess Denied" => "User can only access own information"}, 403)
        end
      else
        json_response({"Acess Denied" => "User can only access own information"}, 403)
      end
    end
  end
end
