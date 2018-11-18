module V1
  class LocationsController < ApplicationController

    # GET /locations
    def index
      geo_params = {country: "us"}
      @locations=Geocoder.search(params[:query], params: geo_params)
    end

    # GET /locations/attractions
    def attractions
      @attractions = [{"name": "Live Music", "id": 1},
                      {"name": "Performing Arts", "id": 2},
                      {"name": "Movies", "id": 3},
                      {"name": "Fine Dining", "id": 4},
                      {"name": "Outdoor Activities", "id": 5},
                      {"name": "Water", "id": 6},
                      {"name": "Medical Center", "id": 7},
                      {"name": "University", "id": 8},
                      {"name": "Good Schools", "id": 9},
                      {"name": "The Country", "id": 10}
                    ]
      json_response(@attractions)
    end

    def downtown_importance
      @options = [{"name": "Very Important", "value": 100},
                      {"name": "Somewhat Important", "value": 50},
                      {"name": "Not Important", "value": 0},
                    ]
      json_response(@options)
    end

  end
end
