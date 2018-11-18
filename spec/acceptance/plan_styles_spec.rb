require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "PlanStyles" do
  header "Accept", :format 
  header "Content-Type", "application/json"

  let(:format) { 'application/json' }
  
  let!(:plan_styles) { create_list(:plan_style, 25) }
  let!(:id) { plan_styles.sample.id }

  let(:page_size) { Faker::Number.between(1, plan_styles.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/plan_styles" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "List all plan_styles" do
      do_request
      result_compare_with_db(json, PlanStyle)
      expect(status).to eq(200)
    end

    example "Get all plan_styles, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, PlanStyle)
      expect(status).to eq(200)
    end

    example_request "Get all plan_styles, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, PlanStyle)
      expect(status).to eq(200)
    end

    example_request "Get all plan_styles, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, PlanStyle)
      expect(status).to eq(200)
    end
  end

  get "/plan_styles/:id/plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all plans from plan_style" do
      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example "Get all plans from plan_style, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from plan_style, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from plan_style, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end
  end
end
