require_relative 'string_ext.rb'


class Metronome

    attr_reader :running, :current_click, :next_click_time
    attr_accessor :bpm, :audible

    DEFAULT_BPM = [36,72,108,144,180,216]
    EMPTY_CLICK_ARRAY = {
        "2/4" => [" 1 "," 2 "],
        "3/4" => [" 1 "," 2 "," 3 "],
        "4/4" => [" 1 "," 2 "," 3 "," 4 "],
        "2/8" => [" 1 "," & "," 2 "," & "],
        "3/8" => [" 1 "," & "," 2 "," & "," 3 "," & "],
        "4/8" => [" 1 "," & "," 2 "," & "," 3 "," & "," 4 "," & "],
    }

    def initialize(bpm=120, clock="4/4", max_measures=nil)
        @visual = true
        @audible = true
        @bpm=bpm
        @clock=clock
        @clicks = []
        @position = 0
        @running = false
        @max_measures = max_measures
        @measures = 1
        @current_click = nil
        @next_click_time = nil
    end

    def start()
        initialize_click_array()
        @running = true
    end

    def run()
        if @running && next_click?
            increment_click_array()
            @next_click_time = Time.now.to_f + click_intervall()
            @current_click = render_click()
            if not @max_measures.nil? and @measures > @max_measures
                stop()
            end
            return true
        else
            return false
        end
    end

    def stop()
        @running = false
        @current_click = nil
        @next_click_time = nil
        initialize_click_array()
    end

    def pause()
        @running = false
    end

    def continue()
        @running = true
        run()
    end

    def get_click_buffer()
        return @clicks.join(' ') << "\r"
    end

    def get_head_buffer()
        return " #{@bpm} BPM #{@clock} CLOCK #{@measures} Measure: "
    end

    def reset_measures()
        @measures = 1
    end

    def click_intervall()
        return (60.0)/@bpm
    end
private
    def next_click?()
        if @next_click_time.nil?
            return true
        else
            return Time.now.to_f >= @next_click_time
        end
    end

    def initialize_click_array()
        @position = 0
        @clicks = EMPTY_CLICK_ARRAY[@clock].dup
    end

    def increment_click_array()
        if @position >= @clicks.size
            initialize_click_array()
            @measures += 1
        end
        @position += 1
    end

    def render_click()
        @clicks[@position-1] = @clicks[@position-1].colorize(7,1)
        @current_click = {
            :click_intervall => click_intervall(),
            :next_click_time => @next_click_time,
            :bpm => @bpm,
            :clock => @clock,
            :measures => @measures,
            :max_measures => @max_measures,
            :position => @position,
            :clicks =>@clicks,
        }

        if @audible
            clock_pos = EMPTY_CLICK_ARRAY[@clock][@position-1].gsub('&','and')
            @current_click[:audible_cmd] = "ogg123 /usr/share/sounds/ubuntu/stereo/bell.ogg -q"
        end

        return @current_click
    end

end
