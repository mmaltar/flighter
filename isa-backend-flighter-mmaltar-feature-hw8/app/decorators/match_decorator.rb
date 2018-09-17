class MatchDecorator < SimpleDelegator
  def home_team
    home_team_name
  end

  def away_team
    away_team_name
  end

  def score
    "#{home_team_goals} : #{away_team_goals}"
  end
end
