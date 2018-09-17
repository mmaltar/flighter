class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :param_missing
  rescue_from ActionController::UnpermittedParameters, with: :param_missing
  rescue_from Pundit::NotAuthorizedError, with: :authorization_failed

  skip_before_action :verify_authenticity_token
  before_action :require_authentication

  def matches
    if params[:date]
      render json: WorldCup.matches_on(params[:date])
    else
      render json: WorldCup.matches
    end
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end

  def require_authentication
    return if current_user
    render json: { errors: { token: ['is invalid'] } },
           status: :unauthorized
  end

  private

  def not_found
    render json: { errors: { resource: ["doesn't exist"] } }, status: :not_found
  end

  def param_missing(exception)
    render json: { errors: { "#{exception.param}": ['is missing'] } },
           status: :bad_request
  end

  def authorization_failed
    render json: { errors: { resource: ['is forbidden'] } }, status: :forbidden
  end
end
