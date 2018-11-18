module V1
  class LotsController < ApplicationController
    before_action :set_community, only: [:index, :create]
    before_action :set_lot, only: [:show, :update, :destroy, :plans]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]

    # GET /communities/:community_id/lots
    def index
      @paged = @community.lots.paged(params)
    end

    # GET /lots/:id
    def show
      @lot
    end

    # POST /communities/:community_id/lots
    def create
      @lot = @community.lots.new(lot_params)
      if @lot.save
        json_response(@lot, :created)
      else
        json_response_error(@lot.errors.full_messages)
      end
    end

    # PUT /lots/:id
    def update
      if @lot.update(lot_params)
        head :no_content
      else
        json_response_error(@lot.errors.full_messages)
      end
    end

    # DELETE /lots/:id
    def destroy
      if @lot.destroy
        head :no_content
      else
        head 422
      end
    end

    #GET lots/x/plans
    def plans
      @paged = @lot.plans.paged(params)
      render 'v1/plans/index'
    end

    private

    def lot_params
      params.permit(:latitude, :longitude, :information, :price, :sqft, :name, :location, :length, :width, :setback_front, :setback_back, :setback_left, :setback_right)
    end

    def set_community
      @community = Community.find(params[:community_id])
    end

    def set_lot
      @lot = Lot.find_by!(id: params[:id])
    end
  end
end