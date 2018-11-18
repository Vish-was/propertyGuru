module ApiSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response_body)
  end

  def response_size
    json['results'].size
  end

  def paged_size(objects, per_page = nil, page = 1)
    per_page = per_page || Rails.configuration.default_page_size
    objects_left = objects.size - ((page-1) * per_page)
    objects_left = 0 if objects_left < 0
    (objects_left >= per_page) ? per_page : objects_left
  end

  def result_compare_with_db(results, klass)
    skip_list = ["lot_boxes", "thumbnail_image", "plan_image", "base_image", "image", "plan_name", "community_base_prices"]

    return true if results['results'].size <= 0

    first_result = results['results'][0]
    id = first_result['id']
    object = klass.find(id)
    for key in (first_result.keys - skip_list)
      expect(first_result[key].to_s).to eq(object.public_send(key).to_s)
    end
  end

  def check_login(user)
    user.add_role(:admin)
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
  end

end