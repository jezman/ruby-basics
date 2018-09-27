class PassengerTrain < Train
  include Validation

  attr_accessor_with_history :route

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :passenger)
  end

  def attach_wagon(wagon)
    super(wagon) if wagon.passenger?
  end
end
