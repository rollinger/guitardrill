require_relative '../lib/guitar_note_class.rb'

puts "Guitar Note Tests"

a = GuitarNote.new(6,0)
p a
a.set_location(1,13)
p a
#p a.find_locations(note='E',octave=nil)
a.set_note('A',[1,4],-0)
p a
