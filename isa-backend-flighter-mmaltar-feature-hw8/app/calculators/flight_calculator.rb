class FlightCalculator
  attr_reader :flight

  def initialize(flight)
    @flight = flight
  end

  def price
    if Time.current >= flight.flys_at
      double_price
    elsif Time.current + 15.days <= flight.flys_at
      base_price
    else
      calculate_price.to_i
    end
  end

  private

  def base_price
    flight.base_price
  end

  def calculate_price
    (15 - ((flight.flys_at - Time.current) / 1.day).to_i) / 15.0 *
      flight.base_price + flight.base_price
  end

  def double_price
    2 * flight.base_price
  end
end
