require_relative '../lib/note_class.rb'

puts "Note Tests"

a = Note.new('A')
puts a
p a
a.set_note('B',[2,4],2,:normal)
puts a
p a
