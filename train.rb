require_relative 'instance_counter'
require_relative 'manufacturer'

class Train
  include InstanceCounter
  include Manufacturer

  attr_reader :number, :speed, :type, :wagons, :route, :station_index

  @@trains = []

  def self.find(number)
    @@trains.detect { |train| train.number == number }
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = init_speed
    @@trains << self
    register_instance
  end

  def gain_speed(value)
    @speed += value
  end

  def reset_speed(value)
    @speed = value < @speed ? @speed -= value : 0
  end

  def attach_wagon(wagon)
    @wagons << wagon if stopped?
  end

  def detach_wagon(wagon)
    @wagons.delete(wagon) if stopped? && !@wagons.empty?
  end

  def route=(route)
    @route = route
    @station_index = source_station_index
    current_station.take(self)
  end

  def current_station
    route.stations[@station_index]
  end

  def next_station
    route.stations[@station_index + 1] unless last_station?
  end

  def previous_station
    route.stations[@station_index - 1] unless first_station?
  end

  def forward
    return unless next_station
    current_station.send(self)
    next_station.take(self)
    @station_index += 1
  end

  def backward
    return unless previous_station
    current_station.send(self)
    previous_station.take(self)
    @station_index -= 1
  end

  def cargo?
    @type == :cargo
  end

  def passenger?
    @type == :passenger
  end

  # ниже, все методы являются помошниками для публичных методов.
  # они так же используются в подклассах, поэтому protected
  protected

  def init_speed
    0
  end

  def source_station_index
    0
  end

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
