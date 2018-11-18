module V1
  class RegionsController < ApplicationController
    before_action :set_builder, only: [:index, :create]
    before_action :set_builder_region, only: [:show, :update, :destroy]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]

    # GET /builders/:builder_id/regions
    def index
      @paged = @builder.regions.paged(params)
    end

    # GET /regions/:id
    def show
      @region
    end

    # POST /builders/:builder_id/regions
    def create
      @region = @builder.regions.new(region_params)
      if @region.save
        json_response(@region, :created)
      else
        json_response_error(@region.errors.full_messages)
      end
    end

    # PUT /regions/:id
    def update
      if @region.update(region_params)
        head :no_content
      else
        json_response_error(@region.errors.full_messages)
      end
    end

    # DELETE /regions/:id
    def destroy
      if @region.destroy
        head :no_content
      else
        head 422
      end
    end

    private

    def region_params
      params.permit(:name)
    end

    def set_builder
      @builder = Builder.find(params[:builder_id])
    end

    def set_builder_region
      @region = Region.find_by!(id: params[:id])
    end
  end
end
