require_relative '../lib/music_base_class.rb'

class ChromaticScaleTraining

    TRAINING_NAME = "Chromatic Scale Recognition Training"
    TRAINING_DESCRIPTION = "This Training enables you to instantly recognize the chromatic note a number of half steps distance from a start note. The training minimizes the recognition time."
    TRAINING_DATA_FILE_URL = '../data/trainings/chromatic_scale_training.data'

    def initialize()
        @log = []
        @lessons = []
        @current_lesson = nil
        @chromatic = MusicBase.new()
    end

    def train()
        #pre_training()
        system('clear')
        compile_training()
        training()
        post_training()
        log_training()
        next_training()
    end

private

    def training_title()
        return "### " + TRAINING_NAME + " ###"
    end

    def countdown(interval, text="", silent=true)
    	t = Time.new(0)
    	countdown_time_in_seconds = interval # change this value
    	countdown_time_in_seconds.downto(0) do |seconds|
    	  time = text + (t + seconds).strftime('%S') + "\r"
    	  unless silent
    	  	print time
    	  	$stdout.flush
    	  end
    	  sleep 1
    	end
    end

    def pre_training(waiting_time=5)
        puts training_title()
        puts TRAINING_DESCRIPTION
        puts @chromatic.get_chromatic_scale().join(' ')
        countdown( waiting_time.to_i, "Starting in: ", false)
    end

    def compile_training()
        start_note = @chromatic.get_chromatic_scale().random_element
        halfsteps = rand(11)+1
        target_note = @chromatic.get_next_note( start_note, halfsteps )
        instructions = "What is the note that is #{halfsteps} halfsteps away from the note #{start_note} ?"
        short = "#{start_note} + #{halfsteps} = ?? "
        @current_lesson = {
            :instructions => instructions,
            :short => short,
            :target_note => target_note,
        }
    end

    def training(waiting_time=10)
        puts training_title()
        puts @current_lesson[:instructions]
        countdown( waiting_time.to_i, @current_lesson[:short], false)
        guess = gets.chomp()
    end

    def post_training()
        #evaluate the training
    end
    def log_training()
    end
    def next_training()
    end
end
