module WorldCup
  require 'json'

  def self.matches
    response = HTTParty.get('https://worldcup.sfg.io/matches')
    JSON.parse(response.body).map { |e| WorldCup::Match.new(e) }
  end

  def self.matches_on(date)
    response =
      HTTParty.get("https://worldcup.sfg.io/matches?start_date=#{date}")
    JSON.parse(response.body).map { |e| WorldCup::Match.new(e) }
  end
end
