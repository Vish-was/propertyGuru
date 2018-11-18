module V1
  class CommunitiesController < ApplicationController

    before_action :set_community, only: [:show, :update, :destroy, :amenities, :create_communities_amenities, :destroy_communities_amenities, :plans, :create_communities_plans, :update_communities_plans, :destroy_communities_plans]
    before_action :set_division, only: [:index, :create]
    before_action :set_amenity, only: [:create_communities_amenities, :destroy_communities_amenities]
    before_action :set_plan, only: [:create_communities_plans, :update_communities_plans, :destroy_communities_plans]
    before_action :authenticate_user!, only: [:create, :update, :destroy, :create_communities_amenities, :destroy_communities_amenities, :create_communities_plans, :update_communities_plans, :destroy_communities_plans]
    before_action :check_role, only: [:create, :update, :destroy, :create_communities_amenities, :destroy_communities_amenities, :create_communities_plans, :update_communities_plans, :destroy_communities_plans]

    # GET /divisions/:division_id/communities?starts_with=value
    def index
      @paged = @division.communities.filtered_page(params)
    end

    # GET /communities/:id
    def show
      @community
    end

    # POST /divisions/:division_id/communities
    def create
      @community = @division.communities.new(community_params)
      if @community.save
        json_response(@community, :created)
      else
        json_response_error(@community.errors.full_messages)
      end
    end

    # PUT /communities/:id
    def update
      if @community.update(community_params)
        head :no_content
      else
        json_response_error(@community.errors.full_messages)
      end
    end

    # DELETE /communities/:id
    def destroy
      if @community.destroy
        head :no_content
      else
        head 422
      end
    end

    #GET /communities/x/plans
    def plans
      @paged = @community.plans.paged(params)
      render 'v1/plans/index'
    end

    #POST /communities/x/plans/y
    def create_communities_plans
      if @community.plans.include?(@plan)
        json_response(message: "Plan is already added to community")
      else
        @community.communities_plans.create(communities_plans_params)
        @plan_options = PlanOption.joins(:plan_option_set=>:plan).where('plans.id = ?', params[:plan_id])
        @plan_options.each do |plan_option|
          @community.community_plan_options.create({:plan_option_id => plan_option.id, :base_price => plan_option.default_price})
        end
        json_response(message: "Plan is added to community successfully")
      end
    end

    #PUT /communities/x/plans/y
    def update_communities_plans
      if @community.plans.include?(@plan)
        @community.communities_plans.where("plan_id = ?", @plan.id).update(communities_plans_params)
        json_response(message: "Plan is updated from community")
      else
        json_response(message: "Plan is not added to community")
      end
    end

    #DELETE /communities/x/plans/y
    def destroy_communities_plans
      if @community.plans.include?(@plan)
        @community.plans.destroy(@plan)
        @plan_options = PlanOption.joins(:plan_option_set=>:plan).where('plans.id = ?', params[:plan_id])
        @plan_options.each do |plan_option|
          if @community.plan_options.include?(plan_option)
            @community.community_plan_options.where("community_plan_options.plan_option_id = ? ", plan_option).destroy_all
          end
        end
        json_response(message: "Plan is removed from community")
      else
        json_response(message: "Plan is not added to community")
      end
    end

    #GET /communities/x/amenities
    def amenities
      @paged = @community.amenities.paged(params)
      render 'v1/amenities/index'
    end

    #POST /communities/x/amenties/y
    def create_communities_amenities
      if @community.amenities.include?(@amenity)
        json_response(message: "Amenity is already added to community")
      else
        if @community.amenities << @amenity 
          json_response(message: "Amenity is added to community successfully")
        else
          head 422
        end
      end
    end

    #DELETE /communities/x/amenties/y
    def destroy_communities_amenities
      if @community.amenities.include?(@amenity)
        if @community.amenities.delete(@amenity)
          json_response(message: "Amenity deleted from community successfully")
        else
          head 422
        end
      else
        json_response(message: "Amenity does not exist in community")
      end
    end

    private

    def community_params
      params.permit(:name, :location,:yearly_hoa_fees, :property_tax_rate)
    end

    def communities_plans_params
      params.permit(:base_price, :plan_id)
    end

    def set_division
      @division = Division.find(params[:division_id])
    end

    def set_community
      @community = Community.find_by!(id: params[:id])
    end

    def set_plan
      @plan = Plan.find_by!(id: params[:plan_id])
    end

    def set_amenity
      @amenity = Amenity.find_by!(id: params[:amenity_id])
    end
  end
end
