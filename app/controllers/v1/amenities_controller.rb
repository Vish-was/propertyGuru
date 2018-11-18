module V1
  class AmenitiesController < ApplicationController
    before_action :authenticate_user!, only: [:create]
    before_action :check_role, only: [:create]

    #POST /amenities
    def create
      @amenity = Amenity.new(amenity_params)
      if @amenity.save
        json_response(@amenity, :created)
      else
        json_response_error(@amenity.errors.full_messages)
      end
    end

    #GET /amenities?starts_with=value
    def search
      @paged = Amenity.filtered_page(params)
      render 'v1/amenities/index'
    end

    private

    def amenity_params
      params.permit(:name)
    end
  end
end
