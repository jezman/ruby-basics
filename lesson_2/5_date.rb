def leap?(year)
  (year % 400).zero? || ((year % 4).zero? && (year % 100).nonzero?)
end

def yday(day, month, months)
  (month - 1).times { |i| day += months[i] }
  day
end

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

puts 'Введите дату'
day = 1

loop do
  print 'Число: '
  day = gets.to_i
  break if (1..31).cover?(day)

  puts 'Некорректное число, попробуйте еще раз'
end

month = 1

loop do
  print 'Месяц: '
  month = gets.to_i
  break if (1..12).cover?(month)

  puts 'Некорректный месяц, попробуйте еще раз'
end

print 'Год: '
year = gets.to_i

months[1] = 29 if leap?(year)
num = yday(day, month, months)

puts "Порядковый номер даты: #{num}."
