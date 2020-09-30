

class GuitarMeasure

    def initialize(clock=[4,4])
        @clock = clock
        @measure= Array.new()
        def @measure.inspect()
            return self.sort{|a,b| a[0] <=> b[0]}.map {|n| [n[0], n[1].to_s] }
        end
    end

    def get_position_clock()
        return [1,@clock[1]]
    end

    def add_note( position, note )
        raise "GuitarMeasure.add_note(pos,note): #{note.inspect} is not a GuitarNote" unless note.class == GuitarNote
        raise "GuitarMeasure.add_note(pos,note): #{position.inspect} is not a valid Position" unless position_valid?(position)
        @measure.push([position.to_f,note])
    end

private

    def position_valid?( position )
        if position.between?(1.0,@clock[0].to_f+1)
            return true
        end
        return false
    end

end
