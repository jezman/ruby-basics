module Selectors
  def select_type
    puts '[0] - пассажирский'
    puts '[1] - грузовой'
    print '[?] Укажите тип: '
    gets.to_i.zero? ? :passenger : :cargo
  end

  def selects_route_actions(empty)
    puts '[0] - добавить марштур'
    unless empty
      puts '[1] - добавить станцию к машруту'
      puts '[2] - удалить станцию из маршрута'
    end

    print '[?] ваш выбор: '
    gets.to_i
  end

  def  selects_wagon_actions(empty)
    puts '[0] - добавить вагон'
    unless empty
      puts '[1] - отцепить вагон'
      puts '[2] - загрузить вагон'
    end

    print '[?] ваш выбор: '
    gets.to_i
  end

  def select_route
    puts '[!] список маршрутов'
    @routes.each_with_index do |route, index|
      puts "\t#{index} - #{route.name}"
    end

    print '[?] маршрут: '
    route_index = get_index(@routes)

    @routes[route_index]
  end

  def select_stations
    puts '[!] список станций'
    @stations.each_with_index do |station, index|
      puts "\t#{index} - #{station.name}"
    end

    print '[?] станция отправления: '
    source = get_index(@stations)

    print '[?] станция назначения: '
    destination = 0

    loop do
      destination = gets.to_i
      break if destination <= @stations.size - 1
    end

    [source, destination]
  end

  def select_station
    puts '[!] список станций'
    @stations.each_with_index do |station, index|
      puts "\t#{index} - #{station.name}"
    end

    print '[?] выберите станцию: '
    station_index = get_index(@stations)

    @stations[station_index]
  end

  def select_train
    puts '[!] список поездов'
    @trains.each_with_index do |train, index|
      puts "\t#{index} - #{train.number}"
    end

    print '[?] поезд: '
    train_index = get_index(@trains)

    @trains[train_index]
  end

  def select_wagon(train)
    wagons = train.wagons

    raise 'у поезда нет вагонов' if wagons.empty?
    puts '[!] список вагонов'
    wagons.each_with_index do |_, index|
      puts "\t- Вагон ##{index}"
    end

    print '[?] выберите вагон: '
    wagon_index = get_index(wagons)

    wagons[wagon_index]
  rescue StandardError => e
    error(e)
  end

  def selects_train_actions
    puts '[0] - двигаться вперед'
    puts '[1] - двигаться назад'
    print '[?] действие: '
    gets.chomp.to_i
  end

  def get_index(array)
    index = 0
    loop do
      index = gets.to_i
      break if index <= array.size - 1
    end

    index
  end

  def wait_pressing
    print '[.] нажмите для продолжения...'
    gets
  end

  def error(e)
    puts "[-] ОШИБКА: #{e.message}"
  end

  def show_wagons(train)
    puts " - #{get_type(train.type)} поезд №#{train.number} кол-во вагонов:#{train.wagons.size}"
    train.each_wagons do |wagon, i|
      if wagon.cargo?
        print " - - вагон № #{i} - #{get_type(wagon.type)},"
        print " cвободных мест: #{wagon.available_volume},"
        puts " занято: #{wagon.used_volume}"
      else
        print " - - вагон №#{i} - #{get_type(wagon.type)},"
        print " cвободного места : #{wagon.free_seats},"
        puts " занято: #{wagon.occupied_seats}"
      end
    end
  end

  def show_stations
    block = proc { |train| show_wagons train }

    @stations.each do |station|
      puts "[!] станция: #{station.name.capitalize}"
      station.each_trains block
    end
    wait_pressing
  end

  def show_trains
    @trains.each { |train| show_wagons train }
    wait_pressing
  end

  def create_passenger_wagon
    print '[?] укажите количество мест в вагоне: '
    PassengerWagon.new(gets.to_i)
  end

  def create_cargo_wagon
    print '[?] укажите объем вагона: '
    CargoWagon.new(gets.to_i)
  end

  def get_type(type)
    type.eql?(:cargo) ? 'грузовой' : 'пассажирский'
  end
end
