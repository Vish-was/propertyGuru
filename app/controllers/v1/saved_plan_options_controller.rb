module V1
  class SavedPlanOptionsController < ApplicationController
    before_action :authenticate_or_guest
    before_action :set_saved_plan, only: [:index, :create]
    before_action :set_saved_plan_option, only: [:show, :destroy]

     # GET /saved_plans/:saved_plan_id/saved_plan_options
    def index
      @paged = @saved_plan.saved_plan_options.filtered_page(params)
    end

    # GET /saved_plan_options/:id
    def show
      @saved_plan_option
    end

    # POST /saved_plans/:saved_plan_id/saved_plan_options
    def create
      @saved_plan_option = SavedPlanOption.find_by_saved_plan_id_and_plan_option_set_id(params[:saved_plan_id], params[:plan_option_set_id])
      if @saved_plan_option.present?
        if @saved_plan_option.update(saved_plan_option_params)
          head :no_content
        else
          json_response_error(@saved_plan_option.errors.full_messages)
        end
      else
        @saved_plan_option = @saved_plan.saved_plan_options.build(saved_plan_option_params)
        if @saved_plan_option.save
          json_response(@saved_plan_option, :created)
        else
          json_response_error(@saved_plan_option.errors.full_messages)
        end
      end
    end

    # DELETE /plan_option_sets/:id
    def destroy
      if @saved_plan_option.destroy
        head :no_content
      else
        head 422
      end
    end

    private

    def plan_params
      #params.permit(:plan_option_set_id, :plan_option_id)
    end

    def saved_plan_option_params
      params.permit(:quoted_price, :plan_option_set_id, :plan_option_id, :saved_plan_id)
    end

    def set_saved_plan_option
      @saved_plan_option = SavedPlanOption.find_by!(id: params[:id])
      unless current_or_guest_user == @saved_plan_option.saved_plan.user
        json_response({"Acess Denied" => "User can only access own information"}, 403)
      end
    end

    def set_saved_plan
      @saved_plan = SavedPlan.find_by!(id: params[:saved_plan_id])
      unless current_or_guest_user == @saved_plan.user
        json_response({"Acess Denied" => "User can only access own information"}, 403)
      end
    end
  end
end
