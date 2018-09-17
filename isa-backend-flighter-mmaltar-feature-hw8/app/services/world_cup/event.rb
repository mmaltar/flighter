module WorldCup
  class Event
    attr_accessor :id, :type, :player, :time

    def initialize(event = {})
      @id = event['id']
      @type = event['type_of_event']
      @player = event['player']
      @time = event['time']
    end

    def to_s
      "##{id}: #{type}@#{time} - #{player}"
    end
  end
end
