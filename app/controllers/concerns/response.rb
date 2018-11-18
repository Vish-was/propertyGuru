module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def json_response_error(errors_array, status = 422)
    render json: { errors: errors_array }, status: status
  end
end
