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
      when 5 then '1'
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

    puts 'тип поезда:'
    puts '  0 - пассажирский'
    puts '  1 - грузовой'
    type = gets.to_i.zero? ? 'passenger' : 'cargo'

    add_train!(number, type)
  end

  def add_train!(number, type)
    case type
    when 'cargo' then @trains << CargoTrain.new(number)
    when 'passenger' then @trains << PassengerTrain.new(number)
    end
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
    source = 0
    destination = 0

    if @stations.size >= 2
      puts 'СПИСОК СТАНЦИЙ'
      @stations.each_with_index do |station, index|
        puts "#{index} - #{station.name}"
      end

      print 'станция отправления: '
      loop do
        source = gets.to_i
        break if source <= @stations.size - 1
      end

      print 'станция назначения: '
      loop do
        destination = gets.to_i
        break if destination <= @stations.size - 1 && source != destination
      end

      @routes << Route.new(@stations[source], @stations[destination])
    else
      puts 'сперва добавьте хотя бы две станции'
    end
  end

  def add_station_to_route
    station = @stations[select_station]
    @routes[select_route].add(station)
  end

  def remove_station_from_route
    station = @stations[select_station]
    @routes[select_route].remove(station)
  end

  def set_route_to_train
    @trains[select_train].route = @routes[select_route]
  end

  def move_train
    train_index = select_train

    puts '0 - вперед'
    puts '1 - назад'
    case gets.to_i
    when 0 then to_next_station(train_index)
    when 1 then to_previous_station(train_index)
    end
  end

  # def attach_wagon_to_train(train)
  #   train.attach_wagon
  # end
  # def dettach_wagon_from_train(train)
  #   train.attach_wagon
  # end

  def show_stations
    @stations.each do |station|
      puts station.name
      station.trains.each { |train| puts "\t#{train.number}" } unless station.trains.nil?
    end
  end

  private

  def to_next_station(train_index)
    @trains[train_index].forward
  end

  def to_previous_station(train_index)
    @trains[train_index].backward
  end

  def select_station
    station_index = 0

    puts 'СПИСОК СТАНЦИЙ'
    @stations.each_with_index do |station, index|
      puts "#{index} - #{station.name}"
    end

    print 'выберите станцию: '
    loop do
      station_index = gets.to_i
      break if station_index <= @stations.size - 1
    end

    station_index
  end

  def select_train
    train_index = 0

    puts 'СПИСОК ПОЕЗДОВ'
    @trains.each_with_index do |train, index|
      puts "#{index} - #{train.number}"
    end

    print 'поезд: '
    loop do
      train_index = gets.to_i
      break if train_index <= @trains.size - 1
    end

    train_index
  end

  def select_route
    route_index = 0

    puts 'СПИСОК МАРШРУТОВ'
    @routes.each_with_index do |route, index|
      puts "#{index} - #{route.name}"
    end

    print 'маршрут: '
    loop do
      route_index = gets.to_i
      break if route_index <= @routes.size - 1
    end

    route_index
  end
end
