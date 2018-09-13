class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take(train)
    @trains << train
  end

  def recieve(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end