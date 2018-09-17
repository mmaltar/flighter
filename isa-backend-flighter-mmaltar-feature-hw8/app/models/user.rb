class User < ApplicationRecord
  has_secure_password
  has_secure_token
  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
