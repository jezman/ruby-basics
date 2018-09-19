class Route
  include InstanceCounter

  attr_reader :name, :stations

  def initialize(source, destination)
    @stations = [source, destination]
    @name = "#{source.name.capitalize} - #{destination.name.capitalize}"
    register_instance
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
