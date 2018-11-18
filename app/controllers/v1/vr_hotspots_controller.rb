module V1
  class VrHotspotsController < ApplicationController
    before_action :set_vr_scene, only: [:index, :create]
    before_action :set_vr_hotspot, only: [:show, :update, :destroy]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]

    # GET /vr_scenes/:vr_scene_id/vr_hotspots
    def index
      @paged = @vr_scene.vr_hotspots.paged(params)
    end

    #GET /vr_hotspots/:id
    def show
      @vr_hotspot
    end

    #POST /vr_scenes/:vr_scene_id/vr_hotspots
    def create
      @vr_hotspot = @vr_scene.vr_hotspots.new(vr_hotspots_params)
      if @vr_hotspot.save
        json_response(@vr_hotspot, :created)
      else
        json_response_error(@vr_hotspot.errors.full_messages)
      end
    end

    #PUT /vr_hotspots/:id
    def update
      if @vr_hotspot.update(vr_hotspots_params)
        head :no_content
      else
        json_response_error(@vr_hotspot.errors.full_messages)
      end
    end

    #DELETE /vr_scenes/:id
    def destroy
      if @vr_hotspot.destroy
        head :no_content
      else
        head 422
      end
    end

    private
    
    def vr_hotspots_params
      params.permit(:name, :plan_option_set_id, :position, :rotation, :toggle_default, :jump_scene_id, :type, :toggle_method, :show_on_plan_option_id, :hide_on_plan_option_id)
    end

    def set_vr_hotspot
      @vr_hotspot = VrHotspot.find_by!(id: params[:id])
    end

    def set_vr_scene
      @vr_scene = VrScene.find_by!(id: params[:vr_scene_id])
    end
  end
end
