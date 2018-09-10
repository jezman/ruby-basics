def rectangular?(sides)
  sides[0]**2 + sides[1]**2 == sides[2]**2
end

def isoscales?(sides)
  sides[0] == sides[1]
end

sides = []

print 'Введите сторону a: '
sides << gets.to_f
print 'Введите сторону b: '
sides << gets.to_f
print 'Введите сторону c: '
sides << gets.to_f

sides.sort!

if rectangular?(sides)
  puts 'Треугольник является прямоугольным'
  puts 'И равнобедренным' if isoscales?(sides)
else
  puts 'Треугольник не является прямоугольным'
end
