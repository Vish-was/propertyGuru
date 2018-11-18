module V1
  class PlanOptionSetsController < ApplicationController
    before_action :set_plan_option_set, only: [:show, :update, :destroy]
    before_action :set_plan, only: [:index, :create]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]


     # GET /plans/:plan_id/plan_option_sets
    def index
      @paged = @plan.plan_option_sets.paged(params)
    end

    # GET /plan_option_sets/:id
    def show
      @plan_option_set
    end

    # POST plans/:plan_id/plan_option_sets
    def create
      @plan_option_set = @plan.plan_option_sets.new(plan_option_set_params)
      if @plan_option_set.save
        json_response(@plan_option_set, :created)
      else
        json_response_error(@plan_option_set.errors.full_messages)
      end
    end

    # PUT /plan_option_sets/:id
    def update
      if @plan_option_set.update(plan_option_set_params)
        head :no_content
      else
        json_response_error(@plan_option_set.errors.full_messages)
      end
    end

    # DELETE /plan_option_sets/:id
    def destroy
      if @plan_option_set.destroy
        head :no_content
      else
        head 422
      end
    end

    private

    def plan_option_set_params
      params.permit(:name, :position_2d_x,:position_2d_y, :default_plan_option_id, :story)
    end

    def set_plan_option_set
      @plan_option_set = PlanOptionSet.find_by!(id: params[:id])
    end

    def set_plan
      @plan = Plan.find_by!(id: params[:plan_id])
    end
  end
end
