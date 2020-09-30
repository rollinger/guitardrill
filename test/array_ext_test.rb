require_relative '../lib/array_ext.rb'

puts "Array Extension Tests"

arr = [0,1,2,3,4,5,6,7,8,9]
p arr
ring = arr.to_ring
p ring

puts
puts "Test Ring.distance(e1,e2):"
p ring.distance(2,8)
p ring.distance(2,18)

puts
puts "Test Ring.cycles(distance):"
p ring.cycles(5)
p ring.cycles(9)
p ring.cycles(10)
p ring.cycles(-19)
p ring.cycles(-39)
