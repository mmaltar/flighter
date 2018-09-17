class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings

  scope :active, -> { where('flights.flys_at >= ?', Time.current) }

  validates :name, presence: true,
                   uniqueness: { scope: :company_id, case_sensitive: false }
  validates :flys_at, presence: true
  validates :lands_at, presence: true
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validate :flys_at_before_lands_at
  validate :overlapping

  def flys_at_before_lands_at
    errors.add(:lands_at, 'must be after flys_at') if lands_at.present? &&
                                                      flys_at.present? &&
                                                      lands_at <= flys_at
  end

  def overlapping
    return if company.blank? || overlappings.blank?
    errors.add(:flys_at, 'flights from same company must not overlap')
    errors.add(:lands_at, 'flights from same company must not overlap')
  end

  def overlappings
    company.flights
           .where.not(id: id)
           .where('(flys_at, lands_at) OVERLAPS (?, ?)',
                  flys_at, lands_at)
  end
end
