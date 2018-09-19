require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'train/cargo_train'
require_relative 'train/passenger_train'
require_relative 'wagon'
require_relative 'wagon/cargo_wagon'
require_relative 'wagon/passenger_wagon'

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

    puts '0 - пассажирский'
    puts '1 - грузовой'
    print 'тип поезда: '
    type = gets.to_i.zero? ? :passenger : :cargo

    add_train!(number, type)
    puts "#{type.eql?(:cargo) ? 'Грузовой' : 'Пассажирский'} поезд с номером #{number} успешно создан"
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
    attempt += 1
    retry if attempt < 5
  end

  def manage_route
    raise 'Сперва добавьте две станции' if @stations.size < 2

    puts '0 - добавить марштур'
    unless @routes.empty?
      puts '1 - добавить станцию к машруту'
      puts '2 - удалить станцию из маршрута'
    end

    print 'ваш выбор: '
    case gets.to_i
    when 0 then add_route
    when 1 then add_station_to_route
    when 2 then remove_station_from_route
    end
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def add_route
    attempt = 0
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
    route = Route.new(@stations[source], @stations[destination])
    @routes << route
    puts "Маршрут '#{route.name}' добавлен"
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
    attempt += 1
    retry if attempt < 5
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
    raise 'сперва добавьте поезда и маршруты' if @trains.empty? || @routes.empty?
      select_train.route = select_route
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def move_train
    raise 'список поездов пуст' if @trains.empty?
    train = select_train

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
    raise 'Список поездов пуст' if !@trains.empty?
    train = select_train
    wagon = train.cargo? ? CargoWagon.new : PassengerWagon.new

    puts '0 - добавить выгон'
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

  def get_index(array)
    index = 0
    loop do
      index = gets.to_i
      break if index <= array.size - 1
    end

    index
  end
end
