class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :no_of_active_flights

  def no_of_active_flights
    object.flights.active.count
  end
end
