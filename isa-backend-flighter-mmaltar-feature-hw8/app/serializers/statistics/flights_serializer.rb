module Statistics
  class FlightsSerializer < ActiveModel::Serializer
    attributes :flight_id, :revenue, :no_of_booked_seats, :occupancy

    def flight_id
      object.id
    end

    def revenue
      object.revenue.to_i
    end

    def no_of_booked_seats
      object.no_of_booked_seats.to_i
    end

    def occupancy
      0 if object.no_of_seats.zero?
      "#{(no_of_booked_seats * 100 / object.no_of_seats.to_d).round(2)}%"
    end
  end
end
