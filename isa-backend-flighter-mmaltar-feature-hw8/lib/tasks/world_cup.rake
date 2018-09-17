namespace :world_cup do
  desc 'Display world cup scores'
  task :scores, [:date] => [:environment] do |_t, args|
    matches = WorldCup.matches_on(args[:date])
                      .map { |match| MatchDecorator.new(match) }

    tp matches, :venue, :home_team, :away_team, :score
  end
end
