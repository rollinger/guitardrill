
require_relative '../lib/guitar_measure_class.rb'
require_relative '../lib/guitar_note_class.rb'
require_relative '../lib/sequence_class.rb'
require_relative '../lib/yaml_functions.rb'

puts "Guitar Measure Tests"

a = GuitarMeasure.new()
a.add_note(1.0,GuitarNote.new(6,5,[1,8]))
a.add_note(1.5,GuitarNote.new(6,8,[1,8]))
a.add_note(2.0,GuitarNote.new(5,5,[1,8]))
a.add_note(2.5,GuitarNote.new(5,7,[1,8]))
a.add_note(3.0,GuitarNote.new(4,5,[1,8]))
a.add_note(3.5,GuitarNote.new(4,7,[1,8]))

s = Sequence.new()
s.push a
p s

# SAVING
save(s, 'data/sequences/a_minor_pentatonic_01')

# LOADING
s = load('data/sequences/a_minor_pentatonic_01')
p s
