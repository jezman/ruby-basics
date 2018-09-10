print 'Как вас зовут: '
name = gets.chomp.capitalize

growth = 0

loop do
  print 'Ваш рост: '
  growth = gets.chomp.to_f
  break if growth.nonzero?

  puts 'Вы ввели некорректные данные, попробуйте еще раз'
end

perfect_weigth = growth - 110

if perfect_weigth < 0
  puts 'Ваш вес уже оптимальный'
else
  puts "#{name}, ваш идельный вес #{perfect_weigth}кг"
end
