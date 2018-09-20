class CargoWagon < Wagon
  def initialize(volume)
    super(:cargo, volume)
  end

  def available_volume
    free_capacity
  end

  def used_volume
    @used_volume
  end

  def load(volume)
    fill!(volume)
  end
end
