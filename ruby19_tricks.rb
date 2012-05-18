# http://rubyreloaded.com/trickshots
# irb ruby19_tricks.rb
# pry ruby19_tricks.rb
a = -> { }
a.source_location

names = %w{fred jess john}
ages  = [1,2,3]

names.zip(ages)
Hash[names.zip(ages)]

rand(1..20)

x = "h"
puts "test #@x"

require 'ripper'
p Ripper.sexp("puts {}.class")

def test
  p __method__
  p __callee__
end

puts 0b0101010
puts 1e6

str = "Test hello world"

str[/^(\w+).*(\w+)$/,1]
