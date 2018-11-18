module V1
  class CollectionsController < ApplicationController
    before_action :set_region, only: [:index, :create]
    before_action :set_collection, except: [:index, :create]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]

    # GET /regions/:region_id/collections
    def index
      @paged = @region.collections.paged(params)
    end

    # GET /collections/:id
    def show
      @collection
    end

    # GET /collections/:id/plans
    def plans
      @paged = @collection.plans.paged(params)
      render 'v1/plans/index'
    end

    # POST /regions/:region_id/collections
    def create
      @collection = @region.collections.new(collection_params)
      if @collection.save
        json_response(@collection, :created)
      else
        json_response_error(@collection.errors.full_messages)
      end
    end

    # PUT /collections/:id
    def update
      if @collection.update(collection_params)
        head :no_content
      else
        json_response_error(@collection.errors.full_messages)
      end
    end

    # DELETE /collections/:id
    def destroy
      if @collection.destroy
        head :no_content
      else
        head 422
      end
    end

    private

    def collection_params
      params.permit(:name, :information)
    end

    def set_region
      @region = Region.find(params[:region_id])
    end

    def set_collection
      @collection = Collection.find_by!(id: params[:id])
    end
  end
end
