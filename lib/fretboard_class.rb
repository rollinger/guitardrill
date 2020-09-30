require_relative 'string_ext.rb'
require_relative 'fixnum_ext.rb'
require_relative 'music_base_class.rb'
require_relative 'markup_class.rb'

class Fretboard < MusicBase

    attr_accessor :guitar_markup

	def initialize(max_frets=12)
		super()
		@guitar_frets = max_frets
		@guitar_tuning = ['E','A','D','G','B','E']
		@guitar_string_order = ["6th", "5th", "4th", "3rd", "2nd", "1st"]
        @guitar_array = build_guitar_array()
        @guitar_list = build_guitar_list()
        @guitar_markup = Markup.new()
	end

	def render()
		rendered_guitar = build_guitar_string( @guitar_array )
		return rendered_guitar
	end

    def get_positions_of_note(note)
        return @guitar_list.dup.delete_if{|entry| entry[2] != note}
    end

    def get_closest_note_from_position(string, fret, note)
        positions = get_positions_of_note(note)
        closest_distance = positions.each_with_index.map {|note,index| [ (note[0]-string).abs + (note[1]-fret).abs, index ] }.sort {|a,b| a[0] <=> b[0]}[0..1].random_element
        #p closest_distance
        return positions[closest_distance[1]]
    end

    def get_best_position_fit_of_note( note, zero_string, zero_fret, horizontal=0, vertical=0, spread=0 )
        # Finds best position from zero in the vector that horizontal(fret) and vertical(string) constitute.
        # 0 => absolute closest, -1 => negative closest, +1 positive closest
        # Check arguments
        unless [-1,0,1].include? horizontal or [-1,0,1].include? vertical or [0..12].include? spread
            raise "Fretboard.get_best_position_fit_of_note() #{horizontal}, #{vertical} or #{spread} not valid values"
        end

        best_fit = nil
        positions = get_positions_of_note( note )
        transform = positions.each_with_index.map do |pos,idx|
            string_distance = pos[0]-zero_string
            fret_distance = pos[1]-zero_fret
            absolute_distance = string_distance.abs + fret_distance.abs
            [ string_distance, fret_distance, absolute_distance, pos[2], idx]
        end
        # Make four quadrants (n = negative, p = positive)
        nhnv = transform.select {|e| e[1] <= 0 && e[0] <= 0 }
        nhpv = transform.select {|e| e[1] <= 0 && e[0] >= 0 }
        phnv = transform.select {|e| e[1] >= 0 && e[0] <= 0 }
        phpv = transform.select {|e| e[1] >= 0 && e[0] >= 0 }
        lookup = {
            [-1,-1] => nhnv,
            [-1,1] => nhpv,
            [1,-1] => phnv,
            [1,1] => phpv,
            [0,0] => transform,
            [1,0] => phnv + phpv,
            [-1,0] => nhnv + nhpv,
            [0,1] => nhpv + phpv,
            [0,-1] => nhnv + phnv,
        }

        """
        p note
        p [zero_string, zero_fret]
        lookup.each do |k,v|
            p k
            p v
        end
        exit
        """

        # Get the best fit rescue if nil and lookup is not possible
        begin
            # Adjust spread to lookup[] size
            spread = spread.to_i.clamp(0, lookup[ [horizontal,vertical] ].size-1)
            best_fit = positions[ lookup[ [horizontal,vertical] ].sort {|a,b| a[2] <=> b[2] }[spread][4] ]
        rescue
            # Get closest
            best_fit = positions[ lookup[ [0,0] ].sort {|a,b| a[2] <=> b[2] }[0][4] ]
        end

        return best_fit
    end

    def build_shape(notes, horizontal=0, vertical=0, spread=0 )
        notes_position = []
        zero_fret = nil
        zero_string = nil

        notes.each_with_index do | note, index |
            if index == 0
                # random picked :start_note
                notes_position.push( [ get_positions_of_note( note ).sample, :start_note ] )
                zero_string = notes_position[0][0][0]
                zero_fret = notes_position[0][0][1]
            elsif index == notes.size - 1
                # :end_note
                notes_position.push( [ get_best_position_fit_of_note( note, zero_string, zero_fret, horizontal, vertical, spread ), :end_note ] )
            else
                # :play_note
                notes_position.push( [ get_best_position_fit_of_note( note, zero_string, zero_fret, horizontal, vertical, spread ), :play_note ] )
            end
        end
        return notes_position
    end

private

	def build_guitar_string( guitar_array )
		buffer = ""
		guitar_array.each_with_index do | guitar_string_array, guitar_string_array_index |
			buffer << @guitar_string_order.reverse[ guitar_string_array_index ].black_bg_white << " "
			guitar_string_array.each_with_index do | note, note_index |
                # Markup the note and Fret
                buffer << @guitar_markup.compile( note, guitar_string_array_index, note_index )
				note_index == 0 ? buffer << "||".black_bold : buffer << "|".black_bold
			end
			buffer << "\n"
		end
		(0..@guitar_frets).each do |f|
			f == 0 ? buffer <<  sprintf( "    -%-2s---", f ).black_bg_white : buffer <<  sprintf( "-%-2s--", f ).black_bg_white
		end
		buffer << "\n"
		return buffer
	end

	def build_guitar_array()
		array = []
		@guitar_tuning.reverse.each do |string_note|
			string = []
			(0..@guitar_frets).each {|f| string << get_next_note( string_note, f ) }
			array.push(string)
		end
		return array
	end

    def build_guitar_list()
        list = []
        @guitar_array.each_with_index do | guitar_string_array, guitar_string_array_index |
            guitar_string_array.each_with_index do | note, note_index |
                list << [guitar_string_array_index,note_index,note]
            end
        end
        return list
    end
end
