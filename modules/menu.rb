module Menu
  MENU = {
    1 => 'add_station',
    2 => 'add_train',
    3 => 'manage_route',
    4 => 'set_route_to_train',
    5 => 'manage_wagon',
    6 => 'move_train',
    7 => 'show_all!',
    8 => 'trains_history'
  }.freeze

  def run
    loop do
      help
      print '[!] выберите пункт меню: '

      number = gets.to_i
      break if number.zero?
      number.between?(1, 8) ? send(command(number)) : puts('неверный пункт')
    end
  end

  private

  def help
    puts
    puts '[1] - создать станцию'
    puts '[2] - создать поезд'
    puts '[3] - управление маршрутом'
    puts '[4] - назначать маршрут поезду'
    puts '[5] - управление вагонами'
    puts '[6] - переместить поезд по маршруту'
    puts '[7] - вывести список станций с поездами и вагонами'
    puts '[8] - история маршрутов поездов'
    puts '[0] - выход'
    puts
  end

  def command(cmd)
    MENU[cmd].to_sym
  end
end
