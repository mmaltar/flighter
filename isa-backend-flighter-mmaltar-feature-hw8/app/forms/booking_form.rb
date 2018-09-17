class BookingForm < ActiveType::Record[Booking]
  before_save :set_seat_price

  def set_seat_price
    return unless no_of_seats_changed?
    self.seat_price = FlightCalculator.new(flight).price
  end
end
