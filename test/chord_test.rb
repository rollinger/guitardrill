require_relative "../lib/chord_class.rb"

puts "Create Chord by notes"
c = Chord.new(['C','E','G'])
p c
p c.name
p c.notes
puts "Add new note"
c.add_note('B')
p c
p c.name
p c.notes
puts "Remove maj3rd add min3rd"
c.remove_note(4)
c.add_note(3)
p c
p c.name
p c.notes
puts "Add a invalid D "
c.add_note('D')
p c
p c.name
p c.notes
puts "Remove theinvalid D "
c.remove_note('D')
p c
p c.name
p c.notes

puts "Create Chord by name"
c1 = Chord.new("B sus2")
p c1
p c1.name
p c1.notes

puts "Create Chord by name"
c2 = Chord.new("B sus45")
p c2
p c2.name
p c2.notes
