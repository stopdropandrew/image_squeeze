class ImageSqueeze
  def self.image_type(filename)
    return ImageSqueeze::NOT_FOUND unless File.exist?(filename)
  
    case identified_format(filename)
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
  def self.identified_format(filename)
    `identify -format %m #{filename} 2> /dev/null`
  end
end
