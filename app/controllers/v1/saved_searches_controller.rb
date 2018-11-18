module V1
  class SavedSearchesController < ApplicationController
    before_action :set_user, only: [:index, :create]
    before_action :set_saved_search, except: [:index, :create]
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :check_role, only: [:create, :update, :destroy]

    # GET /user/:user_id/saved_searches
    def index
      @paged = @user.saved_searches.paged(params)
    end

    # GET /saved_searches/:id
    def show
      @saved_search
    end

    # POST /users/:user_id/saved_searches
    def create
      saved_search = @user.saved_searches.new(saved_search_params)
      if saved_search.save
        json_response(saved_search, :created)
      else
        json_response_error(saved_search.errors.full_messages)
      end
    end

    # PUT /saved_searches/:id
    def update
      if @saved_search.update(saved_search_params)
        head :no_content
      else
        json_response_error(@saved_search.errors.full_messages)
      end
    end

    # DELETE /saved_searches/:id
    def destroy
      if @saved_search.destroy
        head :no_content
      else
        head 422
      end
    end

    private

    def saved_search_params
      params.permit(:name, :description, :criteria)
    end

    def set_user
      @user = User.find(params[:user_id])
      unless current_user == @user
        json_response({"Acess Denied" => "User can only access own information"}, 403)
      end
    end

    def set_saved_search
      @saved_search = SavedSearch.find_by!(id: params[:id])
      unless current_user == @saved_search.user
        json_response({"Acess Denied" => "User can only access own information"}, 403)
      end
    end
  end
end
