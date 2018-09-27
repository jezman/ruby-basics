require_relative 'station'

class Route
  extend Accessors
  include InstanceCounter
  include Validation

  attr_reader :name, :stations

  strong_attr_accessor :source, Station
  strong_attr_accessor :destination, Station

  validate :source, :presence
  validate :destination, :presence

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
end
