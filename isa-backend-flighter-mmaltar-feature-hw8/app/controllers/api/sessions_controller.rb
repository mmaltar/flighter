module Api
  class SessionsController < ApplicationController
    skip_before_action :require_authentication, only: :create

    def create
      user = User.find_by(email: params.dig(:session, :email))

      if user&.authenticate(params.dig(:session, :password))
        session = Session.new(user: user, token: user.token)
        render json: session, status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :bad_request
      end
    end

    def destroy
      current_user.regenerate_token
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
