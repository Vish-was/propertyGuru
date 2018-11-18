module V1
  class PlanRoomsController < ApplicationController

    # GET /plan_rooms
    def index
      @paged = PlanRoom.paged(params)
    end	
  end
end  	
