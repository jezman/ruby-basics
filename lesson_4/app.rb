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
      when 6 then '1'
      when 7 then show_stations
      when 0 then break
      end
    end
  end

  private

  def add_station
    puts
    print 'название станции: '
    @stations << Station.new(gets.chomp)
  end

  def add_train
    puts
    print 'номер поезда: '
    number = gets.chomp

    puts 'тип поезда:'
    puts '  0 - пассажирский'
    puts '  1 - грузовой'
    type = gets.to_i.zero? ? 'passanger' : 'cargo'

    print 'количество вагонов: '
    wagon = gets.to_i

    add_train!(number, type, wagon)
  end

  def add_train!(number, type, wagon)
    @trains << Train.new(number, type, wagon)
  end

  def manage_route
    puts '0 - добавить марштур'
    puts '1 - добавить станцию к машруту'
    #TODO: remove station from route
    gets.to_i.zero? ? add_route : add_station_to_route
  end

  def add_route
    until @routes.size.zero?
      source = 0
      destination = 0

      puts
      puts 'список станций'
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
    end
  end

  def add_station_to_route
    until @routes.size.zero?
      route_index =0
    
      puts 'список маршрутов'
      @routes.each_with_index do |route, index|
        puts "#{index} - #{route.name}"
      end
      print 'маршрут: '
      loop do
        route_index = gets.to_i
        break if route_index <= @routes.size - 1
      end

      puts
      puts 'список станций'
      @stations.each_with_index do |station, index|
        puts "#{index} - #{station.name}"
      end
      print 'добавить станцию: '
      loop do
        source = gets.to_i
        break if source <= @stations.size - 1
      end
      station = @stations[station_index]
      @routes[route_index].add(station) unless @routes.include?(station)
    end
  end

  def add_wagon_to_train(train)
    train.attach_wagon
  end

  def set_route_to_train
    route_index = 0
    train_index = 0

    puts
    puts 'список маршрутов'
    @routes.each_with_index do |route, index|
      puts "#{index} - #{route.name}"
    end
    print 'маршрут: '
    loop do
      route_index = gets.to_i
      break if route_index <= @routes.size - 1
    end

    puts
    puts 'список поездов'
    @trains.each_with_index do |train, index|
      puts "#{index} - #{train.number}"
    end
    print 'поезд: '
    loop do
      train_index = gets.to_i
      break if train_index <= @trains.size - 1
    end

    @trains[train_index].route = @routes[route_index]
  end

  def to_next_station(train)
    train.forward
  end

  def to_previous(train)
    train.previous
  end

  def remove_station_from_route(station)
    route.remove(station)
  end

  def remove_wagon_from_train(train)
    train.attach_wagon
  end

  def show_stations
    @stations.each do |station|
      puts station.name
      station.trains.each { |train| puts "\t#{train.name}" } unless station.trains.nil?
    end
  end
end
