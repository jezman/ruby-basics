class Wagon
  include Manufacturer
  include Validation

  attr_reader :wagon_type, :used_capacity

  validate :wagon_type, :presence

  def initialize(type, capacity)
    @wagon_type = type
    @capacity = capacity
    @used_capacity = 0
    validate!
  end

  def cargo?
    @wagon_type == :cargo
  end

  def passenger?
    @wagon_type == :passenger
  end

  def free_capacity
    @capacity - @used_capacity
  end

  def load!(count = 1)
    raise 'всё уже занято' if @used_capacity == @capacity
    raise 'не хватает места' if count > free_capacity
    raise 'неверно указано количество' unless count.is_a?(Integer)
    @used_capacity += count
  end
end
