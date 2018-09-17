module WorldCup
  class Match
    attr_accessor :venue, :status, :starts_at
    attr_reader :home_team_goals, :home_team_code, :home_team_name,
                :away_team_goals, :away_team_code, :away_team_name,
                :events, :goals

    def initialize(match = {})
      @venue = match['venue']
      @status = match['status']
      initialize_start(match['datetime'])
      initialize_teams(match)
      initialize_events(match)
    end

    def initialize_teams(match = {})
      @home_team_goals = match.dig('home_team', 'goals')
      @home_team_name = match.dig('home_team', 'country')
      @home_team_code = match.dig('home_team', 'code')
      @away_team_goals = match.dig('away_team', 'goals')
      @away_team_name = match.dig('away_team', 'country')
      @away_team_code = match.dig('away_team', 'code')
    end

    def initialize_start(datetime)
      @starts_at = Time.parse(datetime).utc
    end

    def initialize_events(match = {})
      @events = (match['home_team_events'] + match['away_team_events'])
                .map do |e|
        WorldCup::Event.new(e)
      end
      @goals = @events.select { |e| e.type.include?('goal') }
    end

    def result
      if status == 'future'
        '--'
      else
        "#{home_team_goals} : #{away_team_goals}"
      end
    end

    def to_s
      "##{id}: #{type}@#{time} - #{player}"
    end

    def goals_num
      if status == 'future'
        '--'
      else
        @home_team_goals + @away_team_goals
      end
    end

    def as_json(_opts = {})
      {
        away_team: @away_team_name,
        goals: goals_num,
        home_team: @home_team_name,
        score: result,
        status: @status,
        venue: @venue
      }
    end
  end
end
