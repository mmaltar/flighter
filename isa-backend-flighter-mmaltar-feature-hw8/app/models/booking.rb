class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight, -> { order(:flys_at, :name, :created_at) },
             inverse_of: :bookings

  scope :active, (lambda do
    joins(:flight).where('flights.flys_at >= ?', Time.current).distinct
  end)

  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validate :flight_not_in_past
  validate :overbooking

  def flight_not_in_past
    errors.add(:flight, 'must not fly in past') if flight.present? &&
                                                   flight.flys_at.present? &&
                                                   flight.flys_at < Time.now.utc
  end

  def overbooking
    return unless no_of_seats && flight
    available_seats = flight.no_of_seats - no_of_flight_booked_seats
    errors.add(:flight, "can't be overbooked") if available_seats <
                                                  no_of_seats.to_i
  end

  private

  def no_of_flight_booked_seats
    Booking.where(flight_id: flight.id).where.not(id: id).sum(:no_of_seats)
  end
end
