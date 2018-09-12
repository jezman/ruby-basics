cart = {}

def print_line(count)
  puts '-' * count
end

puts 'Введите "стоп", когда закончите покупки.'
print_line(40)

loop do
  print 'Введите название товара: '
  item = gets.chomp
  break if item.casecmp('стоп').zero?

  print 'Введите цену товара: '
  price = gets.to_f

  print 'Введите количество которое хотите купить: '
  count = gets.to_f

  cart[item] = { price: price, count: count }
end

print_line(68)
print "|#{'Товар'.center(29)}"
print "|#{'Цена за ед.'.center(13)}"
print "|#{'Кол-во'.center(8)}"
puts "|#{'Сумма'.center(13)}|"
sum = 0

cart.each do |item, value|
  sum += value[:price] * value[:count]

  print_line(68)
  print "|#{item.ljust(29)}"
  print "|#{value[:price].to_s.center(13)}"
  print "|#{value[:count].to_s.center(8)}"
  puts "|#{sum.to_s.center(13)}|"
end

print_line(68)
puts "Сумма ваших покупок составила: #{sum}".rjust(68)
