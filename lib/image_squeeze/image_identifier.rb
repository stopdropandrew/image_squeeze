module ImageSqueeze
  class ImageIdentifier
    attr_reader :filename
    
    def initialize(filename)
      @filename = filename
    end
    
    def image_type
      return ImageSqueeze::NOT_FOUND unless File.exist?(filename)
      
      case identified_format
      when /^GIFGIF/
        ImageSqueeze::ANIMATED_GIF
      when /GIF/
        ImageSqueeze::GIF
      when /JPEG/
        ImageSqueeze::JPEG
      when /PNG/
        ImageSqueeze::PNG
      else
        ImageSqueeze::UNKNOWN
      end
        
    end
    
    private
    def identified_format
      `identify -format %m #{filename}`
    end
  end
end
  