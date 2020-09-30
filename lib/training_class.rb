
class Training

    def initialize(fileurl=nil)

    end

    def train(idx=0)
        unless @training.nil?
            # get training, start training
            puts @training[idx]
            sleep 2
            evaluate_training()
        end
    end

    def evaluate_training()
        # Input User (Got it/not quite)
    end

    def next_step()
        # 1: repeat this training
        # 2: next training
        # 3: stop training
    end
end
