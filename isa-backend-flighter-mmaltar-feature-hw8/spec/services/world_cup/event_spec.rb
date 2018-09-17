RSpec.describe WorldCup::Event, :event do
  let(:event) do
    WorldCup::Event.new(
      'id' => 276,
      'type_of_event' => 'goal',
      'player' =>  'Luis SUAREZ',
      'time' => "23'"
    )
  end

  it 'initializes new event with id' do
    expect(event.id).to eq(276)
  end

  it 'initializes new event with type' do
    expect(event.type).to eq('goal')
  end

  it 'initializes new event with player' do
    expect(event.player).to eq('Luis SUAREZ')
  end

  it 'initializes new event with time' do
    expect(event.time).to eq("23'")
  end

  it 'converts to string' do
    expect(event.to_s).to eq("#276: goal@23' - Luis SUAREZ")
  end
end
