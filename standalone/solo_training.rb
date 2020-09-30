# TODO:
# OK     (1) Shape Permutations (reordering of relevant notes [start,beginning])
# OK     (2) Shape Location (make new shape on different starting location)
# O     Allow for more than scale.length notes (12 notes in a pentatonic)
# O     Insert Note
# O     Remove Note
# OK     Write Drill Instructor Program
#           - From saved shape draw randomly
#           - increase speed by 1 and practice 20 measures
#           - Save and next
# ...
# O     REFACTOR THE SCRIPT (Merge Chord and Scale Trainer)
#   O   Classes and Functions
#   O   CMD Handler like Menu & Shortcuts (+/-/1-0)
#   O   Optimized and Standardized Saving Routine



require_relative '../lib/scale_class.rb'
require_relative '../lib/fretboard_class.rb'
require_relative '../lib/metronome_class.rb'
require_relative '../lib/keypressed.rb'

def user_input()
    system("stty raw -echo")
    char = STDIN.read_nonblock(1) rescue nil
    system("stty -raw echo")

    if char == "n"
        return :next_shape
    elsif char == "m"
        return :more_notes
    elsif char == "f"
        return :fewer_notes
    elsif char == "+"
        return :faster
    elsif char == "-"
        return :slower
    elsif char == "d"
        return :delete_shape
    elsif char == "s"
        return :saving_shape
    elsif char == "l"
        return :loading_shape
    elsif char == "i"
        return :drill_instructor
    elsif char == "1"
        return :shape_permutation
    elsif char == "2"
        return :shape_location
    elsif char == "q"
        system("clear")
        puts "Thanks for using GuitarDrill"
        exit
    else
        return nil
    end
end
#
# Saving and loading of training_units
#
def saving_shape(array)
    # Load Data
    training_data = loading_training_data()
    # Shape present? update or append (metronome can be different)
    idx = training_data.find_index {|d|
        d[0] == array[0] and d[1] == array[1] and d[3].guitar_markup == array[3].guitar_markup
    }
    if idx.nil?
        training_data.push( array ) # append
    else
        training_data[idx] = array  # update
    end
    saving_training_data(training_data)
end

def loading_training_data()
    # [
    #    [scale,relevant_notes,metronome,fretboard]
    #    ...
    # ]
    training_data = []
    begin
      File.open(TRAINING_FILENAME, "r") do |file|
        training_data = Marshal.load(file)
      end
    rescue
    end
    return training_data
end

def saving_training_data(data)
    File.open(TRAINING_FILENAME, "w+") do |file|
        file.puts Marshal.dump( data )
    end
end

def loading_shape(current_scale)
    training_data = loading_training_data()
    unit = training_data.find_all {|d| d[0] == current_scale }.sample
    return unit
end

def delete_shape(array)
    training_data = loading_training_data()
    # Shape present? delete
    idx = training_data.find_index {|d|
        d[0] == array[0] and d[1] == array[1] and d[3].guitar_markup == array[3].guitar_markup
    }
    unless idx.nil?
        training_data.delete_at(idx)
    end
    saving_training_data(training_data)
end

TRAINING_FILENAME = "solo_training.data"

SPEED_SCALAR = 5
NOTES_PER_UNIT = 2
# OK Get default values for key,mode,type,additional_notes by argv[]
KEY = ARGV.shift || 'C'
MODE = ARGV.shift || 'major'
TYPE = ARGV.shift || 'diatonic'
ADDITIONAL_NOTES = ARGV || []

# Global Var for Drill Instructor
DRILL_MEASURES = 30
DRILL_SPEED_INCREASE = 1
current_measure_of_drill = nil
starting_measure_of_drill = nil

metronome = Metronome.new(bpm=136,clock="4/4")
fretboard = Fretboard.new()
scale = Scale.new(key=KEY, mode=MODE, type=TYPE, additional_notes=ADDITIONAL_NOTES )
relevant_notes = scale.get_relevant_notes
fretboard.guitar_markup.add_mapping( relevant_notes, nil, nil, :normal_note )



metronome.start
while metronome.running

    input = user_input()
    cmd = input unless input.nil?

    if metronome.run()
        # Change relevant notes each MEASURES_UNTIL_CHANGE
        current_click = metronome.current_click
        if current_click[:measures] == 1 && current_click[:position] == 1 || cmd == :next_shape
            # Generate new set of notes
            relevant_notes = scale.get_relevant_notes.draw(NOTES_PER_UNIT)
            # Build Shape and position of notes
            notes_position = fretboard.build_shape(relevant_notes, horizontal=rand(3)-1, vertical=rand(3)-1, spread=rand(3))
            # Refresh markup
            fretboard.guitar_markup.reset
            fretboard.guitar_markup.add_mapping( scale.get_relevant_notes, nil, nil, :normal_note)
            notes_position.each do |pos|
                fretboard.guitar_markup.add_mapping( pos[0][2], pos[0][0], pos[0][1], pos[1])
            end
            # reset cmd var and metronome
            cmd = nil
            metronome.reset_measures()
        elsif cmd == :more_notes
            NOTES_PER_UNIT += 1
            # reset cmd var
            cmd = :next_shape
        elsif cmd == :fewer_notes
            NOTES_PER_UNIT -= 1
            # reset cmd var
            cmd = :next_shape
        elsif cmd == :faster
            metronome.bpm += SPEED_SCALAR
            # reset cmd var
            cmd = nil
        elsif cmd == :slower
            metronome.bpm -= SPEED_SCALAR
            # reset cmd var
            cmd = nil
        elsif cmd == :saving_shape
            saving_shape([scale,relevant_notes,metronome,fretboard])
            cmd = nil
        elsif cmd == :loading_shape
            # [scale,relevant_notes,metronome,fretboard]
            # Load Unit
            training_unit = loading_shape(current_scale=scale)
            if training_unit.nil?
                cmd = :next_shape
            else
                # Setup shape
                scale = training_unit[0]
                relevant_notes = training_unit[1]
                metronome = training_unit[2]
                fretboard = training_unit[3]
                cmd = nil
            end
        elsif cmd == :delete_shape
            delete_shape( [scale,relevant_notes,metronome,fretboard] )
            cmd = nil # Can be saved again
        elsif cmd == :drill_instructor
            # - From saved shape draw randomly
            # - increase speed by 1 and practice 20 measures
            # - Save and next
            if current_measure_of_drill.nil?
                # New shape
                training_unit = loading_shape(current_scale=scale)
                # Setup shape
                scale = training_unit[0]
                relevant_notes = training_unit[1]
                metronome = training_unit[2]
                fretboard = training_unit[3]
                metronome.bpm += DRILL_SPEED_INCREASE
                starting_measure_of_drill = metronome.current_click[:measures]
                current_measure_of_drill = 1
                metronome.stop()
                # Compile printing Buffer And RENDER
                buffer = scale.name() + "\n" + fretboard.render() + metronome.get_head_buffer + metronome.get_click_buffer()
                system("clear")
                print buffer
                $stdout.flush
                sleep(3)
                metronome.start()
                cmd = :drill_instructor
            elsif current_measure_of_drill > DRILL_MEASURES
                # Save this shape
                saving_shape([scale,relevant_notes,metronome,fretboard])
                current_measure_of_drill = nil
                cmd = :drill_instructor
                # => goto first if clause (get new training unit)
            else
                # Normal operation & track current_measure_of_drill
                current_measure_of_drill = metronome.current_click[:measures] - starting_measure_of_drill
                cmd = :drill_instructor
            end
        elsif cmd == :shape_permutation
            # Get a permutation on the relevant_notes
            relevant_notes = relevant_notes.permutation().to_a.sample
            # Build Shape and position of notes
            notes_position = fretboard.build_shape(relevant_notes, horizontal=rand(3)-1, vertical=rand(3)-1, spread=rand(3))
            # Refresh markup
            fretboard.guitar_markup.reset
            fretboard.guitar_markup.add_mapping( scale.get_relevant_notes, nil, nil, :normal_note)
            notes_position.each do |pos|
                fretboard.guitar_markup.add_mapping( pos[0][2], pos[0][0], pos[0][1], pos[1])
            end
            # reset cmd var and metronome
            cmd = nil
            metronome.reset_measures()
        elsif cmd == :shape_location
            # reset fretboard and set the relevant_notes on new fretboard position
            # Build Shape and position of notes
            notes_position = fretboard.build_shape(relevant_notes, horizontal=rand(3)-1, vertical=rand(3)-1, spread=rand(3))
            # Refresh markup
            fretboard.guitar_markup.reset
            fretboard.guitar_markup.add_mapping( scale.get_relevant_notes, nil, nil, :normal_note)
            notes_position.each do |pos|
                fretboard.guitar_markup.add_mapping( pos[0][2], pos[0][0], pos[0][1], pos[1])
            end
            # reset cmd var and metronome
            cmd = nil
            metronome.reset_measures()
        end

        # Compile printing Buffer And RENDER
        buffer = scale.name() + "\n" + fretboard.render() + metronome.get_head_buffer + metronome.get_click_buffer()
        system("clear")
        print buffer
        $stdout.flush
        if current_click.has_key? :audible_cmd
            system( current_click[:audible_cmd] )
        end
    end
end
