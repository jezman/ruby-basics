module Displays
  def show_routes
    @routes.each_with_index do |route, index|
      puts "  #{index} - #{route.name}"
    end
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "  #{index} - #{station.name}"
    end
  end

  def show_trains
    @trains.each_with_index do |train, index|
      puts "    #{index} - #{train.number}"
    end
  end

  def show_all!
    block = ->(train) { show_train_wagons train }

    puts '[!] список станций'
    Station.all.each_with_index do |station, index|
      puts "#{index} - #{station.name}"
      station.each_trains block
    end
  end

  def show_train_wagons(train)
    print " - #{get_type(train)} поезд №#{train.number},"
    puts " кол-во вагонов:#{train.wagons.size}"

    train.each_wagons do |wagon, index|
      show_wagon(wagon, index)
    end
  end

  def trains_history
    @trains.each do |train|
      puts "история маршрутов поезда #{train.number}:"
      train.route_history.each { |route| puts route.name }
    end
    wait_pressing
  end

  private

  def show_wagon(wagon, index)
    if wagon.cargo?
      print " - - вагон № #{index} - #{get_type(wagon)}, "
      puts "cвободно: #{wagon.free_capacity} занято: #{wagon.used_capacity}"
    else
      print " - - вагон №#{index} - #{get_type(wagon)},"
      print " cвободного места : #{wagon.free_seats},"
      puts " занято: #{wagon.used_seats}"
    end
  end

  def get_type(obj)
    obj.type.eql?(:cargo) ? 'грузовой' : 'пассажирский'
  end
end
