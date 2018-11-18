module V1
  class PlanStylesController < ApplicationController
    before_action :set_plan_style, only: [:plans]

   # GET /plan_styles
   # GET plan_styles/:id/plans?starts_with=value
    def index
      @paged = PlanStyle.filtered_page(params)
    end
    
    # GET plan_styles/:id/plans
    def plans
      @paged = @plan_style.plans.filtered_page(params)
      render 'v1/plans/index'
    end

    private

    def set_plan_style
      @plan_style = PlanStyle.find(params[:id])
    end
  end
end