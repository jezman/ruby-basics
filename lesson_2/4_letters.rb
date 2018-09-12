vowels_array = %w[a e i o u y]
vowels_hash = {}

('a'..'z').each_with_index do |letter, index|
  vowels_hash[letter] = index + 1 if vowels_array.include?(letter)
end

p vowels_hash
