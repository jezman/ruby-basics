num = 1
result = [0, 1]

while num < 100
  result << num
  num = result.last(2).reduce(:+)
end

p result
