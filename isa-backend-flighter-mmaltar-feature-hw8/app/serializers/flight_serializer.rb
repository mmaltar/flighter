class FlightSerializer < ActiveModel::Serializer
  attributes :id, :name, :no_of_seats, :base_price, :flys_at, :lands_at,
             :company_id, :no_of_booked_seats, :company_name, :current_price

  has_many :bookings

  def no_of_booked_seats
    object.bookings.sum(&:no_of_seats)
  end

  def company_name
    object.company.name
  end

  def current_price
    FlightCalculator.new(object).price
  end
end
