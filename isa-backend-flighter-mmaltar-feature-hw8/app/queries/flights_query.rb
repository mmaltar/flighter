class FlightsQuery
  attr_reader :relation

  def initialize(relation: Flight.all)
    @relation = relation
  end

  def with_stats
    relation.left_joins(:bookings)
            .select('flights.*, sum(coalesce(bookings.no_of_seats, 0))
                     as no_of_booked_seats,
                     sum(coalesce(bookings.no_of_seats,0) *
                     coalesce(bookings.seat_price,0))
                     as revenue').group(:id)
  end
end
