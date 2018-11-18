require 'histogram/array'
module V1
  class PlansController < ApplicationController
    before_action :set_plan, only: [:show, :update, :destroy, :communities, :plan_styles, :create_plans_plan_style, :destroy_plans_plan_style, :lots, :create_plans_lots, :destroy_plans_lots, :vr, :viewed_users]
    before_action :set_lot, only: [:create_plans_lots, :destroy_plans_lots]
    before_action :set_plan_style, only: [:create_plans_plan_style, :destroy_plans_plan_style]
    before_action :authenticate_user!, only: [:create_plans_plan_style, :destroy_plans_plan_style, :create_plans_lots, :destroy_plans_lots, :create, :update, :destroy]
    before_action :check_role, only: [:create_plans_plan_style, :destroy_plans_plan_style, :create_plans_lots, :destroy_plans_lots, :create, :update, :destroy]
    before_action :set_collection, only: [:create]

    
    # GET /plans
    def index
      if params[:popular_top]
        plans = Plan.popular_top(params[:popular_top])
        get_results(plans)
      else
        @paged = Plan.filtered_page(params)
      end
    end

    def get_results(plans)
      page = params[:page] || 1
      @paged = {page: page, count: plans.length, results: plans}
    end

    # GET /plans/count
    def count
      json_response(Plan.filter(params).size)
    end

    # GET /plans/:id
    def show
      @plan
    end

    # GET /plans/price_range
    def price_range
      prices = Plan.all.map(&:min_price)
      histogram = prices.histogram(20)
      average = (prices.inject{ |sum, el| sum + el }.to_f / prices.size).round
      json_response({histogram: histogram, average:  average})
    end

    # GET plans/:id/plan_styles?starts_with=value
    def plan_styles
      @paged = @plan.plan_styles.paged(params)
    end

    # GET plans/:id/vr
    def vr
      @plan
    end

    # POST plans/:id/plan_styles/:plan_style_id
    def create_plans_plan_style
      if @plan.plan_styles.include?(@plan_style)
        json_response(message: "Plan style already added to plan")
      else
        if @plan.plan_styles << @plan_style 
          json_response(message: "Plan style added to plan successfully")
        end
      end
    end

    # DELETE plans/:id/plan_styles/:plan_style_id
    def destroy_plans_plan_style
      if @plan.plan_styles.include?(@plan_style)
        if @plan.plan_styles.delete(@plan_style)
          json_response(message: "Plan style deleted from plan successfully")
        else
          head 422
        end
      else
        json_response(message: "Plan style does not exist in plan")
      end
    end

    # POST /collections/:collection_id/plans
    def create
      @plan = @collection.plans.new(plan_params)
      if @plan.save
        json_response(@plan, :created)
      else
        json_response_error(@plan.errors.full_messages)
      end
    end

    # PUT /plans/:id
    def update
      if @plan.update(plan_params)
        head :no_content
      else
        head 422
      end
    end

    # DELETE /plans/:id
    def destroy
      if @plan.destroy
        head :no_content
      else
        head 422
      end
    end


    #GET /plans/x/communities
    def communities
      @paged = @plan.communities.paged(params)
      render 'v1/communities/index'
    end

    #GET plans/x/lots
    def lots
      @paged = @plan.lots.paged(params)
      render 'v1/lots/index'
    end

    #POST /plans/x/lots/y
    def create_plans_lots
      if @plan.lots.include?(@lot)
        json_response(message: "Lot is already added to plan")
      else
        if @plan.lots << @lot 
          json_response(message: "Lot is added to plan successfully")
        end
      end
    end

    #DELETE /plans/x/lots/y
    def destroy_plans_lots
      if @plan.lots.include?(@lot)
        if @plan.lots.delete(@lot)
          json_response(message: "Lot deleted from plan successfully")
        else
          head 422
        end
      else
        json_response(message: "Lot does not exist in plan")
      end
    end

    #GET /plans/:plan_id/viewed_users
    def viewed_users
      @paged = @plan.viewers.group(:id).paged(params)
      render 'v1/users/index'
    end

    private

    def plan_params
      params.permit(:name, :information, :min_price, :min_sqft,
                    :min_bedrooms, :min_bathrooms, :min_garage, :min_stories,
                    :max_price, :max_sqft, :max_stories, :image,
                    :max_bedrooms, :max_bathrooms, :max_garage, :collection_id)
    end

    def set_collection
      @collection = Collection.find(params[:collection_id])	
    end

    def set_plan
      # @plan = Plan.find(26)
      @plan = Plan.find_by!(id: params[:id])
    end

    def set_plan_style
      @plan_style = PlanStyle.find_by!(id: params[:plan_style_id])
    end

    def set_lot
      @lot = Lot.find_by!(id: params[:lot_id])
    end
  end
end