class BookingSerializer < ActiveModel::Serializer
  attributes :id, :no_of_seats, :seat_price, :total_price

  belongs_to :flight, serializer: Bookings::FlightSerializer

  def total_price
    object.no_of_seats * object.seat_price
  end
end
