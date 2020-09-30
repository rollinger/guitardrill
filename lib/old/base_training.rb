require_relative 'music_base_class.rb'


class BaseTraining < MusicBase
    def initialize()
    end
end

class PentatonicScaleTraining < BaseTraining
    def initialize(key,mode='minor')
        @key = key
        @mode = mode
        @metronome = Metronome.new(bpm=60, clock="4/4", max_measures=12)
        @fretboard = Fretboard.new()
        @scale = Scale.new(key='A', mode='minor', type='pentatonic', additional_notes=[] )
        @fretboard.guitar_markup.add_mapping( @scale.get_relevant_notes, nil, nil, :normal_note)
    end

    def build_training()
        start_note = @fretboard.get_random_position(@key)
        puts start_note
        exit
    end
end

train = PentatonicScaleTraining.new(key='A',mode='minor')
train.build_training()


coordination = {
    :name => "Pentatonic Scale Training for the Guitar Fretboard",
    :description => "",
    :measures_unit => 12,
    :variations => {
        :random => {
            :notes => :all,
        },
        :linear => {
            :tempi => [60,200],
            :fret_distance => [1,12],
            :string_distance => [0,5],
            :notes_per_measure => [1,4]
        },
        :static => {
            :fret_range => [0,12],
            :beat => :all
        },
    }
}
