class PassengerTrain < Train
  validate :self, :type, PassengerTrain

  def initialize(number)
    super(number, :passenger)
  end

  def attach_wagon(wagon)
    super(wagon) if wagon.passenger?
  end
end
