ActiveAdmin.register Flight do
  permit_params :name, :no_of_seats, :base_price, :flys_at, :lands_at,
                :company_id
end
