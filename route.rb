require_relative 'instance_counter'
require_relative 'validate'

class Route
  include InstanceCounter
  include Validate

  attr_reader :name, :stations

  def initialize(source, destination)
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

  private

  attr_reader :source, :destination

  def validate!
    unless source.is_a?(Station) && destination.is_a?(Station)
      raise 'Недопустимая станция'
    end
    raise 'Отправление и назначение совпадает' if source.eql?(destination)
  end
end
