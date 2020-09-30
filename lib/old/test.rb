require_relative 'fretboard_class.rb'
require_relative 'scale_class.rb'
require_relative 'metronome_class.rb'

metronome = Metronome.new(bpm=120, clock="4/4", max_measures=12)
fretboard = Fretboard.new()
a_minor_pentatonic = Scale.new(key='A', mode='minor', type='pentatonic', additional_notes=['D#'] )
fretboard.guitar_markup.add_mapping( a_minor_pentatonic.get_relevant_notes, nil, nil, :normal_note)

system "clear"
show_color_table()
puts a_minor_pentatonic.name
puts fretboard.render()
metronome.start()

#a_minor_pentatonic.scale.each do |focus|
#	sleep 3
#end
