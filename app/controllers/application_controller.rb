class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Response
  include ExceptionHandler
  before_action :devise_permitted_parameters, if: :devise_controller?

  protected

  def devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def check_role
    is_admin = current_user&.has_role?(:admin)
    is_builder = current_user&.has_role?(:builder)
    json_response({"Acess Denied" => "User not able to perform this action"}, 403) unless (is_admin || is_builder)
  end

  def authenticate_or_guest
    if current_user.blank?
      unless session[:guest_user_id].present? && User.where(uid: session[:guest_user_id]).first.present?
        json_response({"Error" => "You need to sign in or sign up before continuing"}, 403)
      end
    else
      authenticate_user!
    end
  end
end

