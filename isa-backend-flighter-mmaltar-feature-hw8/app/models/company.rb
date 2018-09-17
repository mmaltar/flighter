class Company < ApplicationRecord
  has_many :flights, dependent: :destroy

  scope :active, (lambda do
    joins(:flights).where('flights.flys_at >= ?', Time.current).distinct
  end)

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
