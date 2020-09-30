require_relative "array_ext.rb"

"""
Base Class for all Music Related Classes.
Defines the chromatic scale and the notation type.
"""
class MusicBase

    CHROMATIC_SCALE_SHARP = [ 'C','C#','D','D#','E','F','F#','G','G#','A','A#','B' ]
	CHROMATIC_SCALE_FLAT = ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B' ]
    # Intervals of halfsteps away from the root or identity note
    INTERVALS = {
        :root => 0,
        :minor_second => 1,
        :major_second => 2,
        :minor_third => 3,
        :major_third => 4,
        :perfect_forth => 5,
        :augmented_forth => 6,
        :diminished_fifth => 6,
        :perfect_fifth => 7,
        :augmented_fifth => 8,
        :minor_sixth => 8,
        :major_sixth => 9,
        :minor_seventh => 10,
        :major_seventh => 11,
        :octave => 12,
    }

    attr_reader :notation

	def initialize()
		@@notation = :sharp
	end

	def get_next_note( note, halfsteps=0 )
        chromatic = get_chromatic_scale()
		idx = chromatic.index( validate_note( note ) )
		return chromatic.ring_access( idx, validate_halfsteps( halfsteps ) )
	end

    def get_chromatic_scale()
        @@notation == :sharp ? chromatic = CHROMATIC_SCALE_SHARP : chromatic = CHROMATIC_SCALE_FLAT
        return chromatic
    end

    def toogle_notation()
        @@notation == :sharp ? @@notation = :flat : @@notation = :sharp
    end

    def get_halfsteps(start_note,end_note)
        chromatic = get_chromatic_scale()
        chromatic.ring_distance(start_note, end_note)
    end

private

    def validate_halfsteps( halfsteps )
        # Returns the semitone distance
        if halfsteps.class == Fixnum
            return halfsteps
        elsif halfsteps.class == Symbol && INTERVALS.has_key?(halfsteps)
            return INTERVALS[halfsteps]
        else
            raise "MusicBase.validate_halfsteps() #{halfsteps} not valid."
        end
    end

    def validate_note( note )
        # Returns only valid notes
        if (CHROMATIC_SCALE_SHARP + CHROMATIC_SCALE_FLAT).include?( note.to_s )
            return note
        else
            raise "MusicBase.validate_note() #{note} not valid."
        end
    end

end
