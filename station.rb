require_relative 'validate'
require_relative 'instance_counter'

class Station
  include Validate
  include InstanceCounter

  NAME_FORMAT = /^[а-я]{3,}$/i

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name.capitalize!
    validation!
    @trains = []
    @@stations << self
    register_instance
  end

  def take(train)
    @trains << train
  end

  def send(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def each_trains(block)
    @trains.each { |train| block.call train }
  end

  private

  def validation!
    raise 'Введите минимум 3 буквы русского алфавита' if @name !~ NAME_FORMAT
  end
end
