module Displays
  def show_routes
    @routes.each_with_index do |route, index|
      puts "\t#{index} - #{route.name}"
    end
  end

  def show_stations
    puts '[!] список станций'
    @stations.each_with_index do |station, index|
      puts "\t#{index} - #{station.name}"
    end
  end

  def show_trains
    @trains.each_with_index do |train, index|
      puts "\t#{index} - #{train.number}"
    end
  end

  def show_all!
    block = ->(train) { show_train_wagons train }

    puts '[!] список станций'
    @stations.each_with_index do |station, index|
      puts "\t#{index} - #{station.name}"
      station.each_trains block
    end
  end

  def show_train_wagons(train)
    puts " - #{get_type(train.type)} поезд №#{train.number} кол-во вагонов:#{train.wagons.size}"

    train.each_wagons do |wagon, i|
      if wagon.cargo?
        print " - - вагон № #{i} - #{get_type(wagon.type)},"
        print " cвободных мест: #{wagon.free_capacity},"
        puts " занято: #{wagon.used_capacity}"
      else
        print " - - вагон №#{i} - #{get_type(wagon.type)},"
        print " cвободного места : #{wagon.free_seats},"
        puts " занято: #{wagon.used_seats}"
      end
    end
  end

  private

  def get_type(type)
    type.eql?(:cargo) ? 'грузовой' : 'пассажирский'
  end
end