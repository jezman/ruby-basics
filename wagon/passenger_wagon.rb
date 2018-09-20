class PassengerWagon < Wagon
  def initialize(number_of_seats)
    super(:passenger, number_of_seats)
  end

  def free_seats
    free_capacity
  end

  def occupied_seats
    @used_capacity
  end

  def take_the_place
    fill!
  end
end
