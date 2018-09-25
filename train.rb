class Train
  extend Accessors
  include InstanceCounter
  include Manufacturer
  include Validation

  NUMBER_FORMAT = /^[a-z0-9]{3}\-?[a-z0-9]{2}$/i

  attr_reader :number, :speed, :train_type, :wagons, :route, :station_index

  strong_attr_accessor :number, Integer
  strong_attr_accessor :speed, Integer
  strong_attr_accessor :route, Route

  validate :train_type, :presence

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def self.all
    @@trains
  end

  def initialize(number, type)
    @number = number
    @train_type = type
    validate!
    @wagons = []
    @speed = init_speed
    @@trains[number] = self
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
    current_station.take_train(self)
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
    current_station.send_train(self)
    next_station.take_train(self)
    @station_index += 1
  end

  def backward
    return unless previous_station
    current_station.send_train(self)
    previous_station.take_train(self)
    @station_index -= 1
  end

  def cargo?
    @train_type == :cargo
  end

  def passenger?
    @train_type == :passenger
  end

  def each_wagons
    @wagons.each_with_index { |w, i| yield w, i }
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
