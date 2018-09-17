module Bookings
  class FlightSerializer < ActiveModel::Serializer
    attributes :id, :name, :flys_at, :lands_at
  end
end
