module V1
  class VrScenesController < ApplicationController
    before_action :set_plan, only: [:index, :create]
    before_action :set_vr_scene, only: [:show, :update, :destroy]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]

    # GET /plans/:plan_id/vr_scenes
    def index
      @paged = @plan.vr_scenes.paged(params)
    end

    #GET /vr_scenes/:id
    def show
      @vr_scene
    end

    #POST /plans/:plan_id/vr_scenes
    def create
      @vr_scene = @plan.vr_scenes.new(vr_scenes_params)
      if @vr_scene.save
        json_response(@vr_scene, :created)
      else
        json_response_error(@vr_scene.errors.full_messages)
      end
    end

    #PUT /vr_scenes/:id
    def update
      if @vr_scene.update(vr_scenes_params)
        head :no_content
      else
        json_response_error(@vr_scene.errors.full_messages)
      end
    end

    #DELETE /vr_scenes/:id
    def destroy
      if @vr_scene.destroy
        head :no_content
      else
        head 422
      end
    end

    private
    
    def vr_scenes_params
      params.permit(:name)
    end

    def set_vr_scene
      @vr_scene = VrScene.find_by!(id: params[:id])
    end

    def set_plan
      @plan = Plan.find_by!(id: params[:plan_id])
    end
  end
end
