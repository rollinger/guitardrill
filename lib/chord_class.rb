require_relative "music_base_class.rb"
require_relative "note_class.rb"

"""
Defines musical element Chord
containing two or more notes
"""
class Chord < MusicBase

    MARKUP = {
        :root => :red_note_bg,
        :minor_second => :normal_note,
        :major_second => :normal_note,
        :minor_third => :green_note,
        :major_third => :green_note_bg,
        :perfect_forth => :normal_note,
        :augmented_forth => :normal_note,
        :diminished_fifth => :blue_note,
        :perfect_fifth => :blue_note_bg,
        :augmented_fifth => :blue_note,
        :minor_sixth => :normal_note,
        :major_sixth => :normal_note,
        :minor_seventh => :normal_note,
        :major_seventh => :normal_note,
        :octave => :red_note,
    }

    CHORD_FORMULAS = {
        "maj" => [0, 4, 7],
        "min" => [0, 3, 7],
        "dim" => [0, 3, 6],
        "aug" => [0, 3, 8],
        "sus2" => [0, 2, 7],
        "sus4" => [0, 5, 7],
        "7" => [0, 4, 7, 10],
        "maj7" => [0, 4, 7, 11],
        "min7" => [0, 3, 7, 10],
        "dim7" => [0, 3, 6, 10],
        "min/maj7" => [0, 3, 7, 11],
        "5" => [0, 7],

        # That is tricky and involves a octave jump
        #"6" => [0, 4, 7, 9],
        #"min6" => [0, 3, 7, 9],
        # add 9: 1 3 5 9
        # add 11: 1 3 5 11
        # add 13: 1 3 5 13
        # 9: 1 3 5 b7 9
        # 11: 1 3 5 b7 9 11 13
        # 13: 1 3 5 b7 9 11 13
    }

    def initialize(args)
        super()
        @root = nil
        @intervals = []
        @valid_chord = true
        if args.class == String
            # Initialize by Name
            setup_chord_by_name( args )
        elsif args.class == Array
            # Initialize by Note
            setup_chord_by_notes( args )
        else
            raise "Chord.new(*args) Arguments not allowed"
        end

    end

    def name()
        # Returns the name based on the @chord hash
        extention = CHORD_FORMULAS.key(@intervals)
        extention.nil? ? extention = "[unknown]" : nil
        return @root + ' ' + extention
    end

    def get_relevant_notes()
        return notes()
    end

    def notes()
        # Returns an array of note strings
        return @intervals.map{|i| get_next_note( @root, i ) }
    end

    def add_note(note)
        change_chord_composition(note, true)
    end

    def remove_note(note)
        change_chord_composition(note, false)
    end

    def get_markup()
        # Return the Chord notes and the markup
        markup = notes.each_with_index.map { |n,i|
            [n, MARKUP[ INTERVALS.key(@intervals[i])] ]
        }
        return markup
    end

    def set_random_permutation()
        initialize( "#{@root} #{CHORD_FORMULAS.keys.sample}" )
    end

private

    def change_root(root_note)
        # Set up all intervals given the root note
        @root = sanitize_note(root_note)
        @intervals[0] = 0
    end

    def setup_chord_by_notes( notes )
        notes.each_with_index do |note,index|
            # Build intervalls and set @chord composition
            index == 0 ? change_root(note) : change_chord_composition(note)
        end
    end

    def change_chord_composition(note, add=true)
        # find the interval of the note given the root and store the interval to chord
        note = sanitize_note(note)
        interval = get_halfsteps( @root, note )
        if add
            @intervals.push(interval)
        else
            @intervals.delete(interval)
        end
        check_validity_of_chord()
    end

    def setup_chord_by_name( name )
        # Decode the name
        root_note, extention = name.split(' ')
        if extention.nil?
            extention = 'maj'
        end
        change_root(root_note)
        intervals = CHORD_FORMULAS[extention]
        unless intervals.nil?
            @intervals = intervals
        end
        check_validity_of_chord()
    end

    def sanitize_note(note)
        # Convert a Note Class to String
        if note.class == Note
            note = note.note
        elsif note.class == Fixnum
            note = get_next_note( @root, note )
        end
        return note
    end

    def check_validity_of_chord()
        # Keep intervals in order and uniq
        @intervals = @intervals.uniq.sort
        # Chords must have at least two notes
        if @intervals.size < 2
            return @valid_chord = false
        end
        # Check Chord interval bounds
        intervalbounds = (2..4)
        @intervals.each_cons(2) do |i|
            unless intervalbounds.include?( i[1]-i[0] )
                return @valid_chord = false
            end
        end
        return @valid_chord = true
    end

end
