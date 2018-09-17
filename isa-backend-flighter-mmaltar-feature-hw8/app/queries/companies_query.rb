class CompaniesQuery
  attr_reader :relation

  def initialize(relation: Company.all)
    @relation = relation
  end

  def with_stats
    relation.left_joins(flights: :bookings)
            .select('companies.*, sum(coalesce(bookings.no_of_seats, 0))
                     as total_no_of_booked_seats,
                     sum(coalesce(bookings.no_of_seats, 0) *
                         coalesce(bookings.seat_price, 0))
                     as total_revenue').group(:id)
  end
end
