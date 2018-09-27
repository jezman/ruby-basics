class CargoWagon < Wagon
  extend Accessors
  include Validation

  validate :volume, :presence
  strong_attr_accessor :volume, Integer

  def initialize(volume)
    super(:cargo, volume)
  end
end
