require_relative "note_class.rb"

"""
Defines Guitar Note with Fretboard Coordinates
"""
class GuitarNote < Note

    def initialize( string_init, fret_init, duration_init=[1,4], style_init=:normal )
        @@guitar_tuning = ['E','A','D','G','B','E']
        @@guitar_e0_pos = [24,19,14,9,5,0]
        @@guitar_frets = [0,24]
        super(nil, duration_init=[1,4], octave_init=0, style_init=:normal)
        set_location(string_init,fret_init)
    end

    def to_s
        return "#{@note} #{@octave} (#{@duration[0]}/#{@duration[1]}) [#{@string},#{@fret}]"
    end

    def set_location(string,fret)
        self.string=(string)
        self.fret=(fret)
        @note = find_note(@string,@fret)
        @octave = find_octave(@string,@fret)
    end

    def find_locations(note=nil, octave=nil)
        #Test: http://visualguitar.com/vg-pro/
        locations = []
        @@guitar_tuning.reverse.each_index do |string|
            (@@guitar_frets[0]..@@guitar_frets[1]).to_a.each do |fret|
                n = find_note(string+1,fret)
                o = find_octave(string+1,fret)
                if note.nil? or n == note
                    if octave.nil? or o == octave
                        locations.push([string+1,fret,n,o])
                    end
                end
            end
        end
        return locations.sort { |a, b| [a[3],a[2],a[1],a[0]] <=> [b[3],b[2],b[1],b[0]] }
    end

    def set_note(note, duration=[1,4], octave=0, style=:normal)
        locations = find_locations(note,octave)
        # TODO: Still chooses the first location
        # => should be able to choose nearest neighbor
        #p locations
        set_location(locations[0][0],locations[0][1])
    end

private

    def string=(value)
        if (1..6).include?(value)
            @string = value
            return value
        else
            raise "GuitarNote.string=(value) Value out of bounds"
        end
    end

    def fret=(value)
        if (@@guitar_frets[0]..@@guitar_frets[1]).include?(value)
            @fret = value
            return value
        else
            raise "GuitarNote.fret=(value) Value out of bounds"
        end
    end

    def find_note(string,fret)
        return get_next_note( @@guitar_tuning.reverse[string-1], fret )
    end

    def find_octave(string,fret)
        note_zero_octave = @@guitar_e0_pos.reverse[string-1] + get_halfsteps('E',find_note(string,fret))
        octave = (note_zero_octave-fret)/-12
        return octave
    end

end
