class Route
  include Accessors
  include InstanceCounter
  include Validation

  attr_reader :name, :stations

  validate :route, :presence
  validate :self, :type, Route

  def initialize(source, destination)
    @self = self
    @source = source
    @destination = destination
    @stations = [@source, @destination]
    validate!
    @name = "#{@source.name.capitalize} - #{@destination.name.capitalize}"
    register_instance
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def remove(station)
    first_last = [@stations.first, @stations.last]
    @stations.delete(station) if first_last.none?(station)
  end

  def route
    @stations.each { |station| puts station }
  end
end
