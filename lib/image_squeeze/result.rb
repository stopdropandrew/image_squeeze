module ImageSqueeze
  class Result
    def initialize(options = {})
      @filename = options[:filename]
      @new_filename = options[:new_filename]
    end
    
    def optimized?
      return false unless File.exist?(@filename) && @new_filename && File.exist?(@new_filename)
      File.size?(@filename) > File.size?(@new_filename)
    end
  end
end