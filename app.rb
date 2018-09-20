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
    puts '[1] - создать станцию'
    puts '[2] - создать поезд'
    puts '[3] - управление маршрутом'
    puts '[4] - назначать маршрут поезду'
    puts '[5] - управление вагонами'
    puts '[6] - переместить поезд по маршруту'
    puts '[7] - вывести список станций с поездами и вагонами'
    puts '[0] - выход'
    puts
  end

  def run
    loop do
      help
      print '[!] выберите пункт меню: '
      # choice = gets.to_i

      case gets.to_i
      when 1 then add_station
      when 2 then add_train
      when 3 then manage_route
      when 4 then set_route_to_train
      when 5 then manage_wagon
      when 6 then move_train
      when 7 then show_stations
      when 8 then show_trains
      when 0 then break
      end
    end
  end

  def add_station
    attempt = 0
    print '[?] введите название станции: '
    station_name = gets.chomp
    station = Station.new(station_name)
    @stations << station
    puts "[+] станция '#{station_name}' успешно создана"
    wait_pressing
  rescue StandardError => e
    error(e)
    attempt += 1
    retry if attempt < 5
  end

  def add_train
    attempt = 0

    print '[?] номер поезда: '
    number = gets.chomp
    type = select_type

    add_train!(number, type)
    puts "[+] #{type.eql?(:cargo) ? 'грузовой' : 'пассажирский'} поезд с номером #{number} успешно создан"
    wait_pressing
  rescue StandardError => e
    error(e)
    attempt += 1
    retry if attempt < 5
  end

  def manage_route
    raise 'сперва добавьте две станции' if @stations.size < 2

    case selects_route_actions(@routes.empty?)
    when 0 then add_route
    when 1 then add_station_to_route
    when 2 then remove_station_from_route
    end
  rescue StandardError => e
    error(e)
    wait_pressing
  end

  def add_route
    attempt = 0
    source, destination = select_stations
    route = Route.new(@stations[source], @stations[destination])
    @routes << route
    puts "[+] маршрут '#{route.name}' добавлен"
    wait_pressing
  rescue StandardError => e
    error(e)
    attempt += 1
    retry if attempt < 5
  end

  def add_station_to_route
    station = select_station
    route = select_route
    route.add(station)
    puts "[+] станция #{station.name.capitalize} добавлена к маршруту"
    wait_pressing
  end

  def remove_station_from_route
    station = select_station
    route = select_route
    route.remove(station)
    puts "[+] станция #{station.name.capitalize} удалена из маршрута"
    wait_pressing
  end

  def set_route_to_train
    raise 'сперва добавьте поезда и маршруты' if @trains.empty? || @routes.empty?
    train = select_train
    train.route = select_route
    puts "[+] поезду №#{train.number} назначен маршрут '#{train.route.name}'"
    wait_pressing
  rescue StandardError => e
    error(e)
    wait_pressing
  end

  def move_train
    raise 'список поездов пуст' if @trains.empty?
    train = select_train

    case selects_train_actions
    when 0 then to_next_station(train)
    when 1 then to_previous_station(train)
    end
  rescue StandardError => e
    error(e)
    wait_pressing
  end

  def manage_wagon
    attempt = 0
    raise 'список поездов пуст' if @trains.empty?
    train = select_train

    case selects_wagon_actions(train.wagons.empty?)
    when 0
      wagon = train.cargo? ? create_cargo_wagon : create_passenger_wagon
      train.attach_wagon(wagon)
      puts '[+] вагон успешно прицеплен'
      wait_pressing
    when 1 then detach_wagon(train)
    when 2 then load_wagon(train)
    end
  rescue StandardError => e
    error(e)
    attempt += 1
    retry if attempt < 5
  end

  private

  def add_train!(number, type)
    case type
    when :cargo then @trains << CargoTrain.new(number)
    when :passenger then @trains << PassengerTrain.new(number)
    end
  end

  def load_wagon(train)
    wagon = select_wagon(train)
    if wagon.cargo?
      puts '[?] объем: '
      wagon.load!(gets.to_i)
      puts '[!] вагон успешно загружен'
    else
      wagon.load!
      puts '[!] место успешно занято'
    end
  end

  def detach_wagon(train)
    wagon = select_wagon(train)
    train.detach_wagon(wagon)
    puts '[+] вагон успешно отцеплен'
    wait_pressing
  end

  def to_next_station(train)
    train.forward
    puts "[+] поезд прибыл на станцию #{train.current_station}"
  end

  def to_previous_station(train)
    train.backward
    puts "[+] поезд вернулся на станцию #{train.current_station}"
  end
end
