class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end

  def attach_wagon(wagon)
    @wagons << wagon if stopped? && wagon.passenger?
  end

  def detach_wagon(wagon)
    @wagons.delete(wagon) if stopped? && !@wagons.empty? && wagon.passenger?
  end
end
