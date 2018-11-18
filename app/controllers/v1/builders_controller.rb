module V1
  class BuildersController < ApplicationController
    before_action :set_builder, except: [:index, :create]
    before_action :authenticate_user!, only: [:create, :update, :destroy, :create_users_builders, :destroy_users_builders]
    before_action :check_role, only: [:create, :update, :destroy, :create_users_builders, :destroy_users_builders]
    before_action :set_user, only: [:create_users_builders, :destroy_users_builders]
    before_action :check_admin, only: [:create_users_builders, :destroy_users_builders]
    
    # GET /builders
    def index
      @paged = Builder.paged(params)
    end

    # GET /builders/:id
    def show
      @builder
    end

    # POST /builders
    def create
      @builder = Builder.new(builder_params)
      if @builder.save
        json_response(@builder, :created)
      else
        json_response_error(@builder.errors.full_messages)
      end
    end

    # PUT /builders/:id
    def update
      if @builder.update(builder_params)
        head :no_content
      else
        json_response_error(@builder.errors.full_messages)
      end
    end

    # DELETE /builders/:id
    def destroy
      if @builder.destroy
        head :no_content
      else
        head 422
      end
    end

    # GET /builders/:id/users
    def users
      @paged = @builder.users.filtered_page(params)
      render 'v1/users/index'
    end

    # GET /builders/:id/communities
    def communities
      @paged = Community.includes(:division=> {:region => :builder }).where(builders: {id: params[:id]}).paged(params)
      render 'v1/communities/index'
    end
    
    # GET /builders/:id/collections
    def collections
      @paged = Collection.includes(:region=>:builder).where(builders: {id: params[:id]}).paged(params)
      render 'v1/collections/index'
    end

    # GET /builders/:id/plans
    def plans
      @paged = Plan.includes(:collection => {:region => :builder}).where(builders: {id: params[:id]}).filtered_page(params)
      render 'v1/plans/index'
    end

    # POST /builders/:id/users/:id
    def create_users_builders
      if @builder.users.include?(@user)
        json_response(message: "User is already added to builder")
      else
        if @builder.users << @user
          json_response(message: "User is added to builder")
        else
          head 422
        end
      end
    end

    # DELETE /builders/:id/users/:id
    def destroy_users_builders
      if @builder.users.include?(@user)
        if @builder.users.delete(@user)
          json_response(message: "User is deleted from builder successfully")
        else
          head 422
        end
      else
        json_response(message: "User does not exist in builder")
      end
    end

    private

    def builder_params
      params.permit(:name, :production, :website, :about, :locations, :logo)
    end

    def set_builder
      @builder = Builder.find_by!(id: params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def check_admin
      is_admin = current_user.has_role? :admin rescue false
      json_response({"Acess Denied" => "User not able to perform this action"}, 403) unless (is_admin)
    end
  end
end
