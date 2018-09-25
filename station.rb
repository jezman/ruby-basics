class Station
  include Validation
  include InstanceCounter

  NAME_FORMAT = /^[а-я]{3,}$/i

  attr_reader :name, :trains

  validate :name, :presence
  validate :name, :format, NAME_FORMAT

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name.capitalize!
    @trains = []
    @@stations << self
    validate!
    register_instance
  end

  def take_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def each_trains(block)
    @trains.each { |train| block.call train }
  end
end
