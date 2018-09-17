class Route
  attr_reader :stations

  def initialize(source, destination)
    @stations = [source, destination]
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def remove(station)
    @stations.delete(station) if [@stations.first, @stations.last].none?(station)
  end

  def route
    @stations.each { |station| puts station }
  end
end
