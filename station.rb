require_relative 'validate'
require_relative 'instance_counter'

class Station
  NAME_FORMAT = /^[а-я]{3,}$/i

  include Validate
  include InstanceCounter

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
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
    raise 'Название должно содержать как минимум 3 буквы русского алфавита' if @name !~ NAME_FORMAT
  end
end
