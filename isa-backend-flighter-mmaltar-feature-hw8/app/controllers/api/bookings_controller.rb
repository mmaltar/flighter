module Api
  class BookingsController < ApplicationController
    def index
      if params[:filter] == 'active'
        render json: current_user.bookings.active.includes(:flight)
                                 .order(:created_at)
      else
        render json: current_user.bookings.includes(:flight)
                                 .order(:created_at)
      end
    end

    def show
      authorize(booking)
      render json: booking
    end

    def create
      form = BookingForm.new(booking_params.merge(user: current_user))
      if form.save
        render json: form, status: :created, serializer: BookingSerializer
      else
        render json: { errors: form.errors }, status: :bad_request
      end
    end

    def update
      authorize(booking)
      form = ActiveType.cast(booking, BookingForm)

      if form.update(booking_params)
        render json: booking, status: :ok
      else
        render json: { errors: form.errors }, status: :bad_request
      end
    end

    def destroy
      authorize(booking)
      booking.destroy
      head :no_content
    end

    private

    def booking
      @booking ||= Booking.find(params[:id])
    end

    def flight
      @flight ||= if params.dig('booking', 'flight_id')
                    Flight.find(params.dig('booking', 'flight_id'))
                  elsif params[:id]
                    booking.flight
                  end
    end

    def update_seat_price
      FlightCalculator.new(flight).price
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :flight_id)
    end
  end
end
