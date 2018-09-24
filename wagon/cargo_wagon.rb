class CargoWagon < Wagon
  validate :self, :type, CargoWagon

  def initialize(volume)
    super(:cargo, volume)
  end
end
