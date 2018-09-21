require_relative 'displays'

module Selectors
  include Displays

  def ask_train
    print '[?] номер поезда: '
    number = gets.chomp
    type = select_type

    [number, type]
  end

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
    show_routes
    print '[?] маршрут: '

    @routes[get_index(@routes)]
  end

  def select_stations
    puts '[!] список станций'
    show_stations

    print '[?] станция отправления: '
    source = get_index(@stations)

    print '[?] станция назначения: '
    destination = get_index(@stations)

    [source, destination]
  end

  def select_station
    puts '[!] список станций'
    show_stations

    print '[?] выберите станцию: '
    @stations[get_index(@stations)]
  end

  def select_train
    puts '[!] список поездов'
    show_trains

    print '[?] поезд: '
    @trains[get_index(@trains)]
  end

  def select_wagon(train)
    wagons = train.wagons

    raise 'у поезда нет вагонов' if wagons.empty?
    puts '[!] список вагонов'
    wagons.each_with_index do |_, index|
      puts "\t- Вагон ##{index}"
    end

    print '[?] выберите вагон: '
    wagons[get_index(wagons)]
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

  def error(err)
    puts "[-] ОШИБКА: #{err.message}"
  end

  def create_passenger_wagon
    print '[?] укажите количество мест в вагоне: '
    PassengerWagon.new(gets.to_i)
  end

  def create_cargo_wagon
    print '[?] укажите объем вагона: '
    CargoWagon.new(gets.to_i)
  end
end
