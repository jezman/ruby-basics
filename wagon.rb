require_relative 'validate'
require_relative 'manufacturer'

class Wagon
  include Manufacturer
  include Validate

  attr_reader :type, :used_capacity

  def initialize(type, capacity)
    @type = type
    @capacity = capacity
    @used_capacity = 0
    validate!
  end

  def cargo?
    @type == :cargo
  end

  def passenger?
    @type == :passenger
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

  protected

  def validate!
    raise 'Неуказан тип вагона' if @type.nil?
    raise 'Неверный тип вагона' unless %i[cargo passenger].include?(@type)
    raise 'Неверное указано количество' unless @capacity.is_a?(Integer)
  end
end
