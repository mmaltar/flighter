module Api
  class FlightsController < ApplicationController
    def index
      if params[:company_id]
        render json: Flight.active.includes(:company, :bookings)
          .where(company_id: params_ids).order(:flys_at, :name, :created_at)
      else
        render json: Flight.active.includes(:company, :bookings)
                           .order(:flys_at, :name, :created_at)
      end
    end

    def show
      render json: flight
    end

    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: flight, status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def update
      if flight.update(flight_params)
        render json: flight, status: :ok
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def destroy
      flight.destroy
      head :no_content
    end

    private

    def flight
      @flight ||= Flight.find(params[:id])
    end

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price, :flys_at,
                                     :lands_at, :company_id)
    end

    def params_ids
      params[:company_id].split(',').map(&:to_i)
    end
  end
end
