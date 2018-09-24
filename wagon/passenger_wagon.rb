class PassengerWagon < Wagon
  alias free_seats free_capacity
  alias used_seats used_capacity

  validate :self, :type, PassengerWagon

  def initialize(number_of_seats)
    super(:passenger, number_of_seats)
  end
end
