ActiveAdmin.register Booking do
  permit_params :no_of_seats, :seat_price, :user_id, :flight_id
end
