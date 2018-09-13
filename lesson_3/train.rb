class Train
  attr_reader :speed, :type, :wagons, :route, :station_index

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
  end

  def gain
    @speed += 5
  end

  def stop
    @speed = 0
  end

  def attach_wagon
    @wagons += 1 if stopped?
  end

  def detach_wagon
    @wagons -= 1 if stopped? && @wagons > 1
  end

  def route=(route)
    @route = route
    @station_index = 0
  end

  def current_station
    route.stations[@station_index]
  end

  def next_station
    route.stations[@station_index + 1] unless last?
  end

  def previous_station
    route.stations[@station_index - 1] unless first?
  end

  def forward
    return unless next_station
    current_station.recieve(self)
    next_station.take(self)
    @station_index += 1 unless last_station?
  end

  def backward
    return unless previous_station
    current_station.recieve(self)
    next_station.take(self)
    @station_index -= 1 unless first_station?
  end

  private

  def stopped?
    @speed.zero?
  end

  def first_station?
    current_station == route.stations.first
  end

  def last_station?
    current_station == route.stations.last
  end
end
