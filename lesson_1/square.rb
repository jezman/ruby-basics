print 'a: '
a = gets.to_f
print 'b: '
b = gets.to_f
print 'c: '
c = gets.to_f

d = b**2 - (4 * a * c)
puts "Дискриминант равен #{d}"

if d > 0
  c = Math.sqrt(d)
  x1 = (-b + c) / (2 * a)
  x2 = (-b - c) / (2 * a)
  puts "Первый корень равен #{x1}"
  puts "Второй корень равен #{x2}"
elsif d.zero?
  x = -b / (2 * a)
  puts "Корень уравнения равен #{x}"
else
  puts 'Корней нет'
end
