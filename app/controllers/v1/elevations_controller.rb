module V1
  class ElevationsController < ApplicationController
    before_action :set_plan, only: [:index, :create]
    before_action :set_elevation, only: [:show, :update, :destroy]

    # GET /plans/:plan_id/elevations
    def index
      @paged = @plan.elevations.paged(params)
    end

    # GET /elevations/:id
    def show
      @elevation
    end

    # # POST /plans/:plan_id/elevations
    # def create
    #   option = @plan.elevations.new(elevation_params)
    #   if option.save
    #       json_response(elevation, :created)
    #   else
    #       json_response_error(option.errors.full_messages)
    #   end
    # end

    # # PUT /elevations/:id
    # def update
    #   if @elevation.update(elevation_params)
    #       head :no_content
    #   else
    #       json_response_error(@elevation.errors.full_messages)
    #   end
    # end

    # # DELETE /elevations/:id
    # def destroy
    #   if @elevation.destroy
    #       head :no_content
    #   else
    #       head 422
    #   end
    # end

    private

    def elevation_params
      # params.permit(:name, :information, :price, :category, :sqft, :image)
    end

    def set_plan
      @plan = Plan.find(params[:plan_id])
    end

    def set_elevation
      @elevation = Elevation.find_by!(id: params[:id])
    end
  end
end