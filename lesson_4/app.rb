require_relative 'route'
require_relative 'station'
require_relative 'train/train'
require_relative 'train/cargo'
require_relative 'train/passenger'
require_relative 'wagon/wagon'
require_relative 'wagon/cargo'
require_relative 'wagon/passenger'

class App
  def initialize
    @routes = []
    @stations = []
    @trains = []
  end

  def help
    puts
    puts 'МЕНЮ'
    puts
    puts '1 - создать станцию'
    puts '2 - создать поезд'
    puts '3 - управление маршрутом'
    puts '4 - назначать маршрут поезду'
    puts '5 - управление вагонами'
    puts '6 - переместить поезд по маршруту'
    puts '7 - вывести список станций и список поездов на станции'
    puts '0 - выход'
    puts
  end

  def run
    loop do
      help
      print 'выберите пункт меню: '
      choice = gets.to_i

      case choice
      when 1 then add_station
      when 2 then add_train
      when 3 then manage_route
      when 4 then set_route_to_train
      when 5 then attach_wagon_to_train
      when 6 then move_train
      when 7 then show_stations
      when 0 then break
      end
    end
  end

  # private

  def add_station
    print 'название станции: '
    @stations << Station.new(gets.chomp)
  end

  def add_train
    print 'номер поезда: '
    number = gets.chomp

    puts '0 - пассажирский'
    puts '1 - грузовой'
    print 'тип поезда: '
    type = gets.to_i.zero? ? 'passenger' : 'cargo'

    add_train!(number, type)
  end

  def manage_route
    puts '0 - добавить марштур'
    puts '1 - добавить станцию к машруту'
    puts '2 - удалить станцию из маршрута'

    case gets.to_i
    when 0 then add_route
    when 1 then add_station_to_route
    when 2 then remove_station_from_route
    end
  end

  def add_route
    if @stations.size >= 2
      puts 'СПИСОК СТАНЦИЙ'
      @stations.each_with_index do |station, index|
        puts "#{index} - #{station.name}"
      end

      print 'станция отправления: '
      source = get_index(@stations)

      print 'станция назначения: '
      destination = 0

      loop do
        destination = gets.to_i
        break if destination <= @stations.size - 1 && source != destination
      end

      @routes << Route.new(@stations[source], @stations[destination])
    else
      puts 'добавьте хотя бы две станции'
    end
  end

  def add_station_to_route
    station = select_station
    select_route.add(station)
  end

  def remove_station_from_route
    station = select_station
    select_route.remove(station)
  end

  def set_route_to_train
    select_train.route = select_route
  end

  def move_train
    train = select_train

    puts '0 - вперед'
    puts '1 - назад'

    case gets.to_i
    when 0 then to_next_station(train)
    when 1 then to_previous_station(train)
    end
  end

  def attach_wagon_to_train
    if !@trains.empty?
      train = select_train

      case train.class
      when PassengerTrain.class then attach_passenger_wagon(train)
      when CargoTrain.class then attach_cargo_wagon(train)
      end
    else
      puts 'список поездов пуст'
    end
  end

  def detach_wagon_from_train
    if !@trains.empty?
      train = select_train

      case train.class
      when PassengerTrain.class then detach_passenger_wagon(train)
      when CargoTrain.class then detach_cargo_wagon(train)
      end
    else
      puts 'список поездов пуст'
    end
  end

  def show_stations
    @stations.each do |station|
      puts station.name
      station.trains.each { |train| puts "\t#{train.number}" } unless station.trains.nil?
    end
  end

  private

  def add_train!(number, type)
    case type
    when 'cargo' then @trains << CargoTrain.new(number)
    when 'passenger' then @trains << PassengerTrain.new(number)
    end
  end

  def attach_passenger_wagon(train)
    train.attach_wagon(PassengerWagon.new)
  end

  def attach_cargo_wagon(train)
    train.attach_wagon(CargoWagon.new)
  end

  def detach_passenger_wagon(train)
    wagon = select_wagon(train)
    train.detach_wagon(wagon)
  end

  def detach_cargo_wagon(train)
    wagon = select_wagon(train)
    train.detach_wagon(wagon)
  end

  def to_next_station(train)
    train.forward
  end

  def to_previous_station(train)
    train.backward
  end

  def select_station
    puts 'СПИСОК СТАНЦИЙ'
    @stations.each_with_index do |station, index|
      puts "#{index} - #{station.name}"
    end

    print 'выберите станцию: '
    station_index = get_index(@stations)

    @stations[station_index]
  end

  def select_train
    puts 'СПИСОК ПОЕЗДОВ'

    @trains.each_with_index do |train, index|
      puts "#{index} - #{train.number}"
    end

    print 'поезд: '
    train_index = get_index(@trains)

    @trains[train_index]
  end

  def select_route
    puts 'СПИСОК МАРШРУТОВ'
    @routes.each_with_index do |route, index|
      puts "#{index} - #{route.name}"
    end

    print 'маршрут: '
    route_index = get_index(@routes)

    @routes[route_index]
  end

  def select_wagon(train)
    wagons = train.wagons

    if !wagons.empty?
      puts 'СПИСОК ВАГОНОВ'
      wagons.each_with_index do |_, index|
        puts "вагон №#{index}"
      end

      print 'выберите вагон: '
      wagon_index = get_index(wagons)

      wagons[wagon_index]
    else
      puts 'у поезда нет вагонов'
    end
  end

  def get_index(array)
    index = 0
    loop do
      index = gets.to_i
      break if index <= array.size - 1
    end

    index
  end
end
