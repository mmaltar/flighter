FactoryBot.define do
  factory :booking do
    user
    flight
    seat_price { FlightCalculator.new(flight).price }
    no_of_seats 4
  end
end
