module Api
  class UsersController < ApplicationController
    skip_before_action :require_authentication, only: :create

    def index
      if params[:query]
        filter_by_query
      else
        render json: User.all.includes(bookings: [flight: :company])
                         .order(:email)
      end
    end

    def show
      authorize(user)

      render json: user
    end

    def create
      user = User.new(user_params)

      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      authorize(user)

      if user.update(user_params)
        render json: user, status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def destroy
      authorize(user)

      user.destroy
      head :no_content
    end

    private

    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email,
                                   :password)
    end

    def filter_by_query
      render json: User.where('email ILIKE ? OR first_name ILIKE ? OR
                               last_name ILIKE ?', "%#{params[:query]}%",
                              "%#{params[:query]}%", "%#{params[:query]}%")
                       .includes(bookings: [flight: :company])
    end
  end
end
