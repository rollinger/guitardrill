# YAML File and Data Handling Base Classes
require 'yaml'
#
# YFile (Base Class for YAML-File Operations)
#
class YFile

    attr_accessor :data
    attr_reader :fileurl, :type

    def initialize( fileurl='' )
        @type = self.class.to_s.downcase
        @fileurl = set_fileurl(fileurl)
        @data = nil
    end

    # Set the fileurl
    def set_fileurl( url )
        @fileurl = url + '_' + @type
    end

    # Get the class of the data
    def get_data_class?
        return @data.class
    end

    # Append Array to Data Routine
    def append(new_data)
    end

    # Save Data Routine
    def save!
        begin
            File.open( @fileurl, "w" ) { |f| YAML.dump(@data, f) }
        rescue
            puts "Fuck"
            return 0
        end
    end

    # Load Data Routine
    def load!
        begin
            @data = YAML.load( File.open( @fileurl, "r" ) )
        rescue
            return 0
        end
    end

    #Checks whether the file exists
    def file_exist?
        return FileTest.exist?(@fileurl)
    end
end
