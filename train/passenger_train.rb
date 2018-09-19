class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end

  def attach_wagon(wagon)
    super(wagon) if wagon.passenger?
  end
end
