require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'train/cargo_train'
require_relative 'train/passenger_train'
require_relative 'wagon'
require_relative 'wagon/cargo_wagon'
require_relative 'wagon/passenger_wagon'
require_relative 'selectors'

class App
  include Selectors

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
      when 5 then manage_wagon
      when 6 then move_train
      when 7 then show_stations
      when 0 then break
      end
    end
  end

  def add_station
    attempt = 0
    print 'Введите название станции: '
    station_name = gets.chomp
    station = Station.new(station_name)
    @stations << station
    puts "Станция '#{station_name}' успешно создана"
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
    attempt += 1
    retry if attempt < 5
  end

  def add_train
    attempt = 0

    print 'номер поезда: '
    number = gets.chomp
    type = select_type

    add_train!(number, type)
    puts "#{type.eql?(:cargo) ? 'Грузовой' : 'Пассажирский'} поезд с номером #{number} успешно создан"
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
    attempt += 1
    retry if attempt < 5
  end

  def manage_route
    raise 'Сперва добавьте две станции' if @stations.size < 2
    choice = select_menu_routes(@routes.empty?)

    case choice
    when 0 then add_route
    when 1 then add_station_to_route
    when 2 then remove_station_from_route
    end
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def add_route
    attempt = 0
    source, destination = select_stations(@stations)
    route = Route.new(@stations[source], @stations[destination])
    @routes << route
    puts "Маршрут '#{route.name}' добавлен"
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
    attempt += 1
    retry if attempt < 5
  end

  def add_station_to_route
    station = select_station(@stations)
    route = select_route(@routes)
    route.add(station)
  end

  def remove_station_from_route
    station = select_station(@stations)
    route = select_route(@routes)
    route.remove(station)
  end

  def set_route_to_train
    raise 'сперва добавьте поезда и маршруты' if @trains.empty? || @routes.empty?
    train = select_train(@trains)
    train.route = select_route(@routes)
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def move_train
    raise 'список поездов пуст' if @trains.empty?
    train = select_train(@trains)

    puts '0 - вперед'
    puts '1 - назад'

    case gets.to_i
    when 0 then to_next_station(train)
    when 1 then to_previous_station(train)
    end
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def manage_wagon
    raise 'Список поездов пуст' if @trains.empty?
    train = select_train(@trains)
    wagon = train.cargo? ? CargoWagon.new : PassengerWagon.new

    puts '0 - добавить вагон'
    puts '1 - отцепить вагон' unless train.wagons.empty?

    case gets.to_i
    when 0 then train.attach_wagon(wagon)
    when 1 then detach_wagon(train)
    end
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
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
    when :cargo then @trains << CargoTrain.new(number)
    when :passenger then @trains << PassengerTrain.new(number)
    end
  end

  def detach_wagon(train)
    wagon = select_wagon(train)
    train.detach_wagon(wagon)
  end

  def to_next_station(train)
    train.forward
  end

  def to_previous_station(train)
    train.backward
  end
end
