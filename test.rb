require_relative 'modules/accessors'

class MetaTest
  extend Accessors

  attr_accessor_with_history :a, :b
  strong_attr_accessor :c, Integer
end

m = MetaTest.new
puts 'attr_accessor_with_history'
p m.a_history
p m.a = 1
p m.a_history
p m.a = 2
p m.a_history
p m.a = 3
p m.a_history

p m.b = 3
p m.b = 2
p m.b = 1
p m.b_history

p m.c = 22

puts 'ERROR!!!'
p m.c = 'some_string'
