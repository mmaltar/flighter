RSpec.describe WorldCup::Match, :match do
  let(:match) do
    WorldCup::Match.new(
      'venue' => 'Kaliningrad',
      'location' => 'Kaliningrad Stadium',
      'status' => 'completed',
      'home_team_country' => 'Croatia',
      'away_team_country' => 'Nigeria',
      'datetime' => '2018-06-16T19:00:00Z',
      'home_team' =>
      {
        'country' => 'Croatia',
        'code' => 'CRO',
        'goals' => 2,
        'penalties' => 0
      },
      'away_team' =>
      {
        'country' => 'Nigeria',
        'code' => 'NGA',
        'goals' => 0,
        'penalties' => 0
      },
      'home_team_events' =>
        [{
          'id' => 80,
          'type_of_event' => 'yellow-card',
          'player' => 'Ivan RAKITIC',
          'time' => "30'"
        },
         {
           'id' => 82,
           'type_of_event' => 'substitution-in',
           'player' => 'Marcelo BROZOVIC',
           'time' => "60'"
         },
         {
           'id' => 84,
           'type_of_event' => 'substitution-out',
           'player' => 'Andrej KRAMARIC',
           'time' => "60'"
         },
         {
           'id' => 87,
           'type_of_event' => 'goal-penalty',
           'player' => 'Luka MODRIC',
           'time' => "71'"
         },
         {
           'id' => 90,
           'type_of_event' => 'substitution-out',
           'player' => 'Ante REBIC',
           'time' => "78'"
         },
         {
           'id' => 91,
           'type_of_event' => 'substitution-in',
           'player' => 'Mateo KOVACIC',
           'time' => "78'"
         },
         {
           'id' => 94,
           'type_of_event' => 'substitution-out',
           'player' => 'Mario MANDZUKIC',
           'time' => "86'"
         },
         {
           'id' => 96,
           'type_of_event' => 'substitution-in',
           'player' => 'Marko PJACA',
           'time' => "86'"
         },
         {
           'id' => 95,
           'type_of_event' => 'yellow-card',
           'player' => 'Marcelo BROZOVIC',
           'time' => "89'"
         }],
      'away_team_events' =>
         [{
           'id' => 81,
           'type_of_event' => 'goal-own',
           'player' => 'Oghenekaro ETEBO',
           'time' => "32'"
         },
          {
            'id' => 83,
            'type_of_event' => 'substitution-in',
            'player' => 'Ahmed MUSA',
            'time' => "62'"
          },
          {
            'id' => 86,
            'type_of_event' => 'substitution-out',
            'player' => 'Alex IWOBI',
            'time' => "62'"
          },
          {
            'id' => 85,
            'type_of_event' => 'yellow-card',
            'player' => 'William EKONG',
            'time' => "70'"
          },
          {
            'id' => 92,
            'type_of_event' => 'substitution-out',
            'player' => 'Odion IGHALO',
            'time' => "72'"
          },
          {
            'id' => 93,
            'type_of_event' => 'substitution-in',
            'player' => 'Kelechi IHEANACHO',
            'time' => "72'"
          },
          {
            'id' => 88,
            'type_of_event' => 'substitution-out',
            'player' => 'Odion IGHALO',
            'time' => "73'"
          },
          {
            'id' => 89,
            'type_of_event' => 'substitution-in',
            'player' => 'Kelechi IHEANACHO',
            'time' => "73'"
          },
          {
            'id' => 97,
            'type_of_event' => 'substitution-out',
            'player' => 'John Obi MIKEL',
            'time' => "88'"
          },
          {
            'id' => 98,
            'type_of_event' => 'substitution-in',
            'player' => 'Simeon NWANKWO',
            'time' => "88'"
          }]
    )
  end

  it 'initializes match venue' do
    expect(match.venue).to eq('Kaliningrad')
  end

  it 'initializes match status' do
    expect(match.status).to eq('completed')
  end

  it 'initalizes match start at' do
    expect(match.starts_at).to eq(Time.new(2018, 6, 16, 19, 0, 0, '+00:00'))
  end

  it 'returns home team goals' do
    expect(match.home_team_goals).to eq(2)
  end

  it 'returns away team goals' do
    expect(match.away_team_goals).to eq(0)
  end

  it 'returns home team code' do
    expect(match.home_team_code).to eq('CRO')
  end

  it 'returns away team code' do
    expect(match.away_team_code).to eq('NGA')
  end

  it 'returns home team country' do
    expect(match.home_team_name).to eq('Croatia')
  end

  it 'returns away team country' do
    expect(match.away_team_name).to eq('Nigeria')
  end

  it 'contains correct number of events' do
    expect(match.events.length).to eq(19)
  end

  it 'contains only events' do
    expect(match.events).to all(be_an(WorldCup::Event))
  end

  it 'contains correct number of goals' do
    expect(match.goals.length).to eq(2)
  end
end
