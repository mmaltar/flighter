module Users
  class BookingSerializer < ActiveModel::Serializer
    attributes :id, :no_of_seats, :seat_price, :flight_name, :flys_at,
               :company_name

    def flight_name
      object.flight.name
    end

    def flys_at
      object.flight.flys_at
    end

    def company_name
      object.flight.company.name
    end
  end
end
