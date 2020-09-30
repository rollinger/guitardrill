require_relative '../lib/chord_class.rb'
require_relative '../lib/fretboard_class.rb'
require_relative '../lib/metronome_class.rb'

def user_input()
    system("stty raw -echo")
    char = STDIN.read_nonblock(1) rescue nil
    system("stty -raw echo")

    if char == "r"
        return :next_root
    elsif char == "n"
        return :next_variation
    elsif char == "e"
        return :enter_chord
    elsif char == "f"
        return :faster
    elsif char == "s"
        return :slower
    elsif char == "q"
        puts "Thanks for using GuitarDrill"
        exit
    else
        return nil
    end
end

SPEED_SCALAR = 3

ROOT = ARGV.shift || 'C'
EXT = ARGV.shift || 'maj'
CHORD = [ROOT,EXT].join(' ')

metronome = Metronome.new(bpm=72,clock="4/4")
metronome.audible = false
fretboard = Fretboard.new()
chord = Chord.new(CHORD)
next_chord = CHORD

metronome.start
while metronome.running

    input = user_input()
    cmd = input unless input.nil?

    if metronome.run()
        # Change relevant notes each MEASURES_UNTIL_CHANGE
        current_click = metronome.current_click
        if current_click[:measures] == 1 && current_click[:position] == 1 || cmd == :next_root
            #Generate a new random Chord
            if next_chord.nil?
                chord = Chord.new( chord.get_chromatic_scale().sample )
            else
                chord = Chord.new( next_chord )
                next_chord = nil
            end
            # Refresh markup
            fretboard.guitar_markup.reset
            fretboard.guitar_markup.add_mapping( chord.get_relevant_notes, nil, nil, :normal_note)
            #p chord.get_markup
            #exit
            chord.get_markup.each do |m|
                puts m.inspect
                fretboard.guitar_markup.add_mapping( m[0], nil, nil, m[1])
            end
            #exit
            # reset cmd var
            cmd = nil
        elsif cmd == :next_variation
            chord.set_random_permutation
            # Refresh markup
            fretboard.guitar_markup.reset
            fretboard.guitar_markup.add_mapping( chord.get_relevant_notes, nil, nil, :normal_note)
            #p chord.get_markup
            #exit
            chord.get_markup.each do |m|
                fretboard.guitar_markup.add_mapping( m[0], nil, nil, m[1])
            end
            # reset cmd var
            cmd = nil
        elsif cmd == :enter_chord
            chord = Chord.new( gets.chomp )
            #print chord.inspect
            #exit
        elsif cmd == :faster
            metronome.bpm += SPEED_SCALAR
            # reset cmd var
            cmd = nil
        elsif cmd == :slower
            metronome.bpm -= SPEED_SCALAR
            # reset cmd var
            cmd = nil
        end

        # Compile printing Buffer
        buffer = chord.name() + " (#{chord.notes().join(', ')})" + "\n" + fretboard.render() + metronome.get_head_buffer + metronome.get_click_buffer()
        system("clear")
        print buffer
        $stdout.flush
        if current_click.has_key? :audible_cmd
            system( current_click[:audible_cmd] )
        end
    end
end
