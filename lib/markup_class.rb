require_relative 'string_ext.rb'
require_relative 'music_base_class.rb'

class Markup < MusicBase

    attr_reader :markups, :mapping

    def initialize( initial_mapping=:hidden_note )
        super()
        @initial_mapping = initial_mapping
        @markups = [:hidden_note,:normal_note,:red_note,:blue_note,:green_note,:play_note,
            :red_note_bg,:blue_note_bg,:green_note_bg]
        @mapping = {}
        reset()
    end

    def ==(guitar_markup)
        if guitar_markup.class == self.class and guitar_markup.mapping == self.mapping
            return true
        end
        return false
    end

    def add_mapping( note, string=nil, fret=nil, name )
        if note.class == Array
            note.each {|n| add_mapping( n,string,fret,name ) }
        else
            if not @mapping.has_key?( [note,string,fret] )
                @mapping[[note,string,fret]]=name
            else
                delete_mapping( note,string,fret,name )
                add_mapping( note,string,fret,name )
            end
        end
    end

    def delete_mapping( note,string,fret,name )
        @mapping.delete( [note,string,fret] )
    end

    def compile( note, string=nil, fret=nil)
        if get_chromatic_scale().include?( note )
            mapping = nil
            if not string.nil? and not fret.nil?
                # Check for markup exact match
                mapping = get_mapping(note,string,fret)
            end
            if mapping.nil?
                # Check for markup general map
                mapping = get_mapping(note,nil,nil)
            end
        else
            mapping = note
        end
        return colorize( note, mapping )
    end

    def reset()
        @mapping = {}
        get_chromatic_scale().each do |note|
            add_mapping( note,nil,nil,@initial_mapping )
        end
    end

private

    def get_mapping(note,string,fret)
        return @mapping[[note,string,fret]]
    end

    def colorize( note, mapping )
        case mapping
        when :hidden_note
            return sprintf( " %-3s", note ).black_bold
        when :normal_note
            return sprintf( " %-3s", note ).white
        when :red_note
            return sprintf( " %-3s", note ).red
        when :blue_note
            return sprintf( " %-3s", note ).blue
        when :green_note
            return sprintf( " %-3s", note ).green
        when :start_note, :green_note_bg
            return sprintf( " %-3s", note ).white_bg_green_bold
        when :end_note, :red_note_bg
            return sprintf( " %-3s", note ).white_bg_red_bold
        when :between_note
            return sprintf( " %-3s", note ).white_bg_red_bold
        when :play_note, :blue_note_bg
            return sprintf( " %-3s", note ).white_bg_blue_bold
        else
            return sprintf( " %-3s", note ).black_bold
        end
    end
end
