class CargoTrain < Train
  def initialize(number)
    super(number, :cargo)
  end

  def attach_wagon(wagon)
    @wagons << wagon if stopped? && wagon.cargo?
  end
   def detach_wagon(wagon)
    @wagons.delete(wagon) if stopped? && !@wagons.empty? && wagon.cargo?
  end
end
