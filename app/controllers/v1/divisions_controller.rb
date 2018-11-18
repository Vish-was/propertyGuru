module V1
  class DivisionsController < ApplicationController
    before_action :set_region, only: [:index, :create]
    before_action :set_division, only: [:show, :update, :destroy]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]

    # GET /regions/:region_id/divisions
    def index
      @paged = @region.divisions.paged(params)
    end

    # GET /divisions/:id
    def show
      @division
    end

    # POST /regions/:region_id/divisions
    def create
      @division = @region.divisions.new(division_params)
      if @division.save
        json_response(@division, :created)
      else
        json_response_error(@division.errors.full_messages)
      end
    end

    # PUT /divisions/:id
    def update
      if @division.update(division_params)
        head :no_content
      else
        json_response_error(@division.errors.full_messages)
      end
    end

    # DELETE /divisions/:id
    def destroy
      if @division.destroy
        head :no_content
      else
        head 422
      end
    end

    # GET division/x/plans?starts_with
    def plans
      @paged = Plan.joins(:collection=>[:region=>:divisions]).where('divisions.id = ?', params[:id]).filtered_page(params)
      render 'v1/plans/index'
    end

    private

    def division_params
      params.permit(:name)
    end

    def set_region
      @region = Region.find(params[:region_id])
    end

    def set_division
      @division = Division.find_by!(id: params[:id])
    end
  end
end
