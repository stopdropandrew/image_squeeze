require 'tempfile'

module ImageSqueeze
  class Processor
    attr_reader :filename
    
    def initialize(filename)
      @filename = filename
      @tempfile = Tempfile.new(File.basename(filename))
    end
    
    def new_filename
      @tempfile.path
    end
    
    def squeeze
      raise "Should be defined in subclass and should put a new file at @tempfile.path"
    end
    
    def cleanup
      # nothing yet
    end
  end
end