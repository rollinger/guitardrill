require_relative "music_base_class.rb"

"""
Defines basic musical element Note
nil as @note represents pause/silence
"""
class Note < MusicBase

    attr_reader :note, :duration, :octave, :style

    def initialize(note_init, duration_init=[1,4], octave_init=0, style_init=:normal)
        super()
        @available_styles = [:normal]
        @note = self.note=(note_init)
        @duration = self.duration=(duration_init)
        @octave = self.octave=(octave_init)
        @style = self.style=(style_init)
    end

    def to_s
        return @note
    end

    def set_note(note, duration=[1,4], octave=0, style=:normal)
        self.note=(note)
        self.duration=(duration)
        self.octave=(octave)
        self.style=(style)
        return self
    end

private

    def note=(value)
        if get_chromatic_scale.include?(value) or value.nil?
            @note = value
            return @note
        else
            raise "Note.note=(value) Value out of bounds"
        end
    end

    def duration=(value)
        if value.class == Array and value.size == 2
            @duration = value
            return @duration
        else
            raise "Note.duration=(value) Value out of bounds"
        end
    end

    def octave=(value)
        if value.class == Fixnum
            @octave = value
            return @octave
        else
            raise "Note.octave=(value) Value out of bounds"
        end
    end

    def style=(value)
        if @available_styles.include?(value)
            @style = value
            return @style
        else
            return nil
        end
    end
end
