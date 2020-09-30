
require_relative '../lib/guitar_note_class.rb'
require_relative '../lib/guitar_measure_class.rb'


puts "Guitar Measure Tests"

a = GuitarMeasure.new()
a.add_note(1.0,GuitarNote.new(6,5,[1,8]))
a.add_note(1.5,GuitarNote.new(6,8,[1,8]))
a.add_note(2.0,GuitarNote.new(5,5,[1,8]))
a.add_note(2.5,GuitarNote.new(5,7,[1,8]))
a.add_note(3.0,GuitarNote.new(4,5,[1,8]))
a.add_note(3.5,GuitarNote.new(4,7,[1,8]))
p a
