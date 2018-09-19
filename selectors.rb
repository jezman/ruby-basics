module Selectors
  def select_type
    puts '0 - пассажирский'
    puts '1 - грузовой'
    print 'Укажите тип: '
    gets.to_i.zero? ? :passenger : :cargo
  end

  def select_menu_routes(empty)
    puts '0 - добавить марштур'
    unless empty
      puts '1 - добавить станцию к машруту'
      puts '2 - удалить станцию из маршрута'
    end

    print 'ваш выбор: '
    gets.to_i
  end

  def select_route(routes)
    puts 'СПИСОК МАРШРУТОВ'
    routes.each_with_index do |route, index|
      puts "#{index} - #{route.name}"
    end

    print 'маршрут: '
    route_index = get_index(@routes)

    routes[route_index]
  end

  def select_stations(stations)
    puts 'СПИСОК СТАНЦИЙ'
    stations.each_with_index do |station, index|
      puts "#{index} - #{station.name}"
    end

    print 'станция отправления: '
    source = get_index(stations)

    print 'станция назначения: '
    destination = 0

    loop do
      destination = gets.to_i
      break if destination <= stations.size - 1
    end

    [source, destination]
  end

  def get_index(array)
    index = 0
    loop do
      index = gets.to_i
      break if index <= array.size - 1
    end

    index
  end

  def select_station(stations)
    puts 'СПИСОК СТАНЦИЙ'
    stations.each_with_index do |station, index|
      puts "#{index} - #{station.name}"
    end

    print 'выберите станцию: '
    station_index = get_index(stations)

    stations[station_index]
  end

  def select_train(trains)
    puts 'СПИСОК ПОЕЗДОВ'
    trains.each_with_index do |train, index|
      puts "#{index} - #{train.number}"
    end

    print 'поезд: '
    train_index = get_index(trains)

    trains[train_index]
  end

  def select_wagon(train)
    wagons = train.wagons

    raise 'у поезда нет вагонов' if wagons.empty?
    puts 'СПИСОК ВАГОНОВ'
    wagons.each_with_index do |_, index|
      puts "Вагон ##{index}"
    end

    print 'выберите вагон: '
    wagon_index = get_index(wagons)

    wagons[wagon_index]
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end
end
