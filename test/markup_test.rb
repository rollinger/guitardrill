require_relative '../lib/markup_class.rb'

puts "Fretboard Tests"

a = Markup.new
a.add_mapping( "B", string=1, fret=7, :red_note )
puts a.inspect
puts a.compile( 'B' )
puts a.compile( 'B',1,7 )
