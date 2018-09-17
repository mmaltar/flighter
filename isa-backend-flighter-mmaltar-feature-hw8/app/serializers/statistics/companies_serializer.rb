module Statistics
  class CompaniesSerializer < ActiveModel::Serializer
    attributes :company_id, :total_revenue, :total_no_of_booked_seats,
               :average_price_of_seats

    def company_id
      object.id
    end

    def total_revenue
      object.total_revenue.to_i
    end

    def total_no_of_booked_seats
      object.total_no_of_booked_seats.to_i
    end

    def average_price_of_seats
      return 0 if total_no_of_booked_seats.zero?
      object.total_revenue / object.total_no_of_booked_seats.to_f
    end
  end
end
