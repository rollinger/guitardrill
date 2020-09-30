require_relative 'string_ext.rb'
require_relative 'music_base_class.rb'

class Scale < MusicBase

    MAJOR_DIATONIC = [0,2,4,5,7,9,11]
    MINOR_DIATONIC = [0,2,3,5,7,8,10]
	MAJOR_PENTATONIC = [0,2,4,7,9]
	MINOR_PENTATONIC = [0,3,5,7,10]

	attr_reader :scale, :additional_notes

	def initialize(key, mode='minor', type='pentatonic', additional_notes=[] )
		super()
		@key = key
		@mode = mode
		@type = type
		@additional_notes = additional_notes
		@scale = []
		create_scale()
	end

    def ==(scale)
        if scale.class == self.class and scale.scale == self.scale and scale.additional_notes == self.additional_notes
            return true
        end
        return false
    end

    def get_relevant_notes()
        notes = @scale + @additional_notes
        return notes
    end

	def name()
		n = "#{@key} #{@mode.capitalize} #{@type.capitalize} Scale"
		n += " (plus: #{@additional_notes.join(', ')})" unless @additional_notes.empty?
		n += " => [#{@scale.join(', ')}]"
		return n
	end

	def create_scale()
		scale_type = @mode.upcase + '_' + @type.upcase
		@scale = eval(scale_type).map {|interval| get_next_note( @key, interval)}
	end

	def is_the_root?( note )
		if note == @scale[0]
			return true
		end
		return false
	end

	def is_the_third?( note )
		if note == @scale[2]
			return true
		end
		return false
	end

	def is_the_fifth?( note )
		if note == @scale[4]
			return true
		end
		return false
	end
end
