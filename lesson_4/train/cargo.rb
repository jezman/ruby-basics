class CargoTrain < Train
  def initialize(number, wagon)
    super(number, 'cargo', wagon)
  end
end
