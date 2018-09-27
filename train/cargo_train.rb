class CargoTrain < Train
  include Validation

  attr_accessor_with_history :route

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :cargo)
  end

  def attach_wagon(wagon)
    super(wagon) if wagon.cargo?
  end
end
