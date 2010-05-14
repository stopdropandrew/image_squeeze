class ImageSqueeze
  class Result
    attr_reader :output_filename, :bytes_saved, :output_extension
    
    def initialize(options = {})
      @filename = options[:filename]
      @output_filename = options[:output_filename]
      @bytes_saved = options[:bytes_saved]
      @output_extension = options[:output_extension]
    end
    
    def optimized?
      bytes_saved.to_i > 0
    end
    
    def <=>(other)
      self.bytes_saved <=> other.bytes_saved
    end
  end
end