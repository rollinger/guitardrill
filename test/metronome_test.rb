require_relative '../lib/metronome_class.rb'

puts "Metronome Tests"

m = Metronome.new(bpm=60)
m.start
while m.running
    if m.run()
        current_click = m.current_click
        print m.get_head_buffer + m.get_click_buffer
        #print current_click[:click_intervall]
        $stdout.flush
        if current_click.has_key? :audible_cmd
           system( current_click[:audible_cmd] )
        end
        m.bpm += 10
    end
end
