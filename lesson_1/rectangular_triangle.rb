def rectangular?(sides)
  sides[0]**2 + sides[1]**2 == sides[2]**2
end

def isoscales?(sides)
  sides[0] == sides[1] || sides[0] == sides[2] || sides[1] == sides[2]
end

def equilateral?(sides)
  sides[0] == sides[1] && sides[0] == sides[2]
end

sides = []

print 'Введите сторону a: '
sides << gets.chomp.to_f
print 'Введите сторону b: '
sides << gets.chomp.to_f
print 'Введите сторону c: '
sides << gets.chomp.to_f

sides.sort!

if equilateral?(sides)
  puts 'Треугольник является равнобедренным и расносторонним'
elsif rectangular?(sides)
  print 'Треугольник является прямоугольным'
  print isoscales?(sides) ? "и равнобедренным\n" : "\n"
else
  puts 'Треугольник не является прямоугольным'
end
