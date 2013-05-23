class ImageSqueeze
  class Result
    attr_reader :filename, :output_filename, :bytes_saved, :output_extension, :original_size
    
    def initialize(options = {})
      @filename = options[:filename]
      @output_filename = options[:output_filename]
      @bytes_saved = options[:bytes_saved]
      @output_extension = options[:output_extension]
      @original_size = options[:original_size]
    end
    
    def optimized?
      bytes_saved.to_i > 0
    end
    
    def <=>(other)
      self.bytes_saved <=> other.bytes_saved
    end

    def percent_savings
      @bytes_saved.to_f/@original_size
    end

  end
end