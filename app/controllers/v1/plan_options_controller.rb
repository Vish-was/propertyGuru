module V1
  class PlanOptionsController < ApplicationController
    before_action :set_plan_option_set, only: [:index, :create]
    before_action :set_plan_option, except: [:index, :create]
    before_action :set_community, only: [:update_plan_options_communities]
    before_action :authenticate_user!, only: [:update_plan_options_communities, :create, :update, :destroy]
    before_action :check_role, only: [:update_plan_options_communities, :create, :update, :destroy]

    # GET /plan_option_sets/:plan_option_set_id/plan_options
    def index
      @paged = @plan_option_set.plan_options.paged(params)
    end

    # GET /plan_options/:id
    def show
      @plan_option
    end

    # GET /plan_options/:id/excluded_plan_options
    def excluded_plan_options
      @excluded_ids = @plan_option.excluded_plan_options
                    .pluck(:excluded_plan_option_id)
    end

    # POST /plan_optoin_sets/:plan_option_set_id/plan_options
    def create
      plan_option = @plan_option_set.plan_options.new(plan_option_params)
      if plan_option.save
        json_response(plan_option, :created)
      else
        json_response_error(plan_option.errors.full_messages)
      end
    end

    # PUT /plan_options/:id
    def update
      if @plan_option.update(plan_option_params)
        json_response(@plan_option, :ok)
      else
        json_response_error(@plan_option.errors.full_messages)
      end
    end

    # DELETE /plan_options/:id
    def destroy
      if @plan_option.destroy
        head :no_content
      else
        head 422
      end
    end

    #GET /plan_options/x/communities
    def communities
      @paged = @plan_option.communities.paged(params)
      render 'v1/communities/index'
    end

    #PUT /plan_options/x/communities/y
    def update_plan_options_communities
      if @plan_option.communities.include?(@community)
        @plan_option.community_plan_options.where('community_id = ?', @community.id).update(communities_plan_options)
        json_response(message: "Community is updated from plan option successfully")
      end
    end

    private

    def plan_option_params
      params.permit(:name, :information, :default_price, :category, :sqft_ac, :plan_id, :story, :plan_image, 
                    :thumbnail_image, :pano_image, :vr_parameter, :type, :sqft_living, :sqft_porch, :sqft_patio,
                    :width, :depth)
    end

    def communities_plan_options
      params.permit(:base_price)
    end

    def set_plan_option_set
      @plan_option_set = PlanOptionSet.find(params[:plan_option_set_id])
    end

    def set_plan_option
      @plan_option = PlanOption.find_by!(id: params[:id])
    end

    def set_community
      @community = Community.find_by!(id: params[:community_id])
    end
  end
end
