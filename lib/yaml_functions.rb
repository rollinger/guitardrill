require 'yaml'

# Save Data Routine
def save(object,fileurl)
    begin
        File.open( fileurl, "w" ) { |f| YAML.dump(object, f) }
        return true
    rescue
        return false
    end
end

# Load Data Routine
def load(fileurl)
    begin
        if FileTest.exist?(fileurl)
            return YAML.load( File.open( fileurl, "r" ) )
        end
    rescue
        return nil
    end
end
