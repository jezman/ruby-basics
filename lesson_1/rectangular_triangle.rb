def rectangular?(sides)
  sides[0]**2 + sides[1]**2 == sides[2]**2
end

def equilateral?(sides)
  sides[0] == sides[1] && sides[0] == sides[2]

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
elsif isoscales?(sides)
  puts 'Треугольник является равнобедренным'
elsif equilateral?(sides)
  puts 'Треугольник равносторонний, но не прямоугольный'
end
