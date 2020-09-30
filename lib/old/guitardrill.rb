CHROMATIC_SCALE = [ ['C '],['C#','Db'],['D '],['D#','Eb'],['E '],['F '],['F#','Gb'],['G '],['G#','Ab'],['A '],['A#','Bb'],['B '] ]
CHROMATIC_SCALE_REDUX = ['C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ' ]

FULLTONE_SCALE_REDUX = ['C ','D ','E ','F ','G ','A ','B ' ]
A_MAJOR_PENTATONIC = ['A ','C ','D ','E ','G ']

GUITAR_STANDARD_TUNING = ['E','A','D','G','B','E']
GUITAR_STRING_ORDER = ["1st", "2nd", "3rd", "4th", "5th", "6th"]

FIRST_GUITAR_STRING = ['E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ']
SECOND_GUITAR_STRING = ['A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#']
THIRD_GUITAR_STRING = ['D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#']
FOURTH_GUITAR_STRING = ['G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#']
FIFTH_GUITAR_STRING = ['B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ']
SIXTH_GUITAR_STRING = ['E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ','F#','G ','G#','A ','A#','B ','C ','C#','D ','D#','E ','F ']
GUITAR_RANGE = [0,24]
GUITAR_INDEX = ['0 ','1 ','2 ','3 ','4 ','5 ','6 ','7 ','8 ','9 ','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25']
GUITAR = [SIXTH_GUITAR_STRING,FIFTH_GUITAR_STRING,FOURTH_GUITAR_STRING,THIRD_GUITAR_STRING,SECOND_GUITAR_STRING,FIRST_GUITAR_STRING]

PRE_TRAINING_INTERVALL = 2
TRAINING_INTERVALL = 5
HELP_INTERVALL = 3


class Array
	def draw()
		return self[rand(self.size)]
	end
end


#
# Prints a guitar layout inside the boundaries of the frets, and string considering only the given notes
#
def print_full_guitar(frets=0..25, notes=FULLTONE_SCALE_REDUX, strings=GUITAR_STRING_ORDER)
	# Deep Copy of guitar
	this_guitar = Marshal.load(Marshal.dump(GUITAR))
	# Remove the notes not wanted
	this_guitar.each_with_index do |guitarstring,index|
		guitarstring.map! do |n|
			if strings.include?(GUITAR_STRING_ORDER[index])
				!notes.include?(n) ? "--" : n
			else
				"--"
			end
		end
	end 
	# Print Guitar
	this_guitar.each_with_index do |guitarstring,index|
		guitarstring.map! { |n| "#{n}|" }
		puts GUITAR_STRING_ORDER[index] + '||' + guitarstring.slice(frets).join('')
	end
	# Print Guitar Index
	puts "   ||" + GUITAR_INDEX.slice(frets).map! { |n| "#{n}|" }.join('')
end

def countdown(intervall, text="", silent=true)
	t = Time.new(0)
	countdown_time_in_seconds = intervall # change this value
	countdown_time_in_seconds.downto(0) do |seconds|
	  time = text + (t + seconds).strftime('%S') + "\r"
	  unless silent
	  	print time
	  	$stdout.flush
	  end
	  sleep 1
	end
end

def get_note(string,fret)
	#puts [string,fret].inspect
	return GUITAR[GUITAR_STRING_ORDER.find_index(string)][fret]
end

def location_training(frets=[0,12])
	# Prepare Training
	#countdown(PRE_TRAINING_INTERVALL,text="Location Training in: ", silent=false)
	string = GUITAR_STRING_ORDER.sample
	fret = (frets[0]..frets[1]).to_a.sample
	note = get_note(string,fret)
	instructions = "Play \"#{string}\" String on fret #{fret} (Note: #{note})."
	# Execute Training
	puts instructions
	# Give Help
	print_full_guitar(frets[0]..frets[1], [note], [string])
	countdown(TRAINING_INTERVALL)
	# Finish Training
	puts "FINISHED"
end

def note_training()
	# Prepare Training
	#countdown(PRE_TRAINING_INTERVALL,text="Note Training in: ", silent=false)
	note = FULLTONE_SCALE_REDUX.sample
	frets = [0,12]
	string = GUITAR_STRING_ORDER.sample
	instructions = "Play Note(s) \"#{note}\" on the #{string} string between frets #{frets[0]} and #{frets[1]}."
	# Execute Training
	puts instructions
	# Give Help
	print_full_guitar(frets[0]..frets[1], [note], [string])
	countdown(TRAINING_INTERVALL)
	# Finish Training
	puts "FINISHED"
end

def chord_training()
end

def scale_training()
end

def improvisation_training()
end

training_library=[
	"note_training",
	"location_training"
]

#while true
#	system "clear"
#	send training_library.sample
#	system "clear"
#	puts "Guitar Fretboard:"
#	print_full_guitar(frets=0..12)
#	sleep 2
#end
system "clear"
print_full_guitar(frets=0..24,notes=A_MAJOR_PENTATONIC)


def color(index)
  normal = "\e[#{index}m#{index}\e[0m"
  bold = "\e[#{index}m\e[1m#{index}\e[0m"
  "#{normal}  #{bold}  " 
end

8.times do|index| 
  line = color(index + 1)
  line += color(index + 30)
  line += color(index + 90)
  line += color(index + 40)
  line += color(index + 100)
  puts line
end
